//
//  DWInvitePeopleViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInvitePeopleViewController.h"

#import "DWConstants.h"
#import "DWContact.h"
#import "ABContactsHelper.h"
#import "DWNavTitleView.h"
#import "DWNavBarRightButtonView.h"
#import "DWSpinnerOverlayView.h"
#import "DWAnalyticsManager.h"
#import "DWGUIManager.h"


static NSString* const kImgTopShadow                        = @"shadow_top.png";
static NSString* const kImgCancel                           = @"button_cancel_left.png";
static NSString* const kNavBarRightButtonText               = @"Done";
static NSString* const kMsgErrorTitle                       = @"Error";
static NSString* const kMsgCancelTitle                      = @"OK";
static NSString* const kMsgDefaultInviteAlertText           = @"You haven't invited anyone yet";
static NSString* const kMsgProcessingText                   = @"Inviting...";
static NSInteger const kTableViewX							= 0;
static NSInteger const kTableViewY							= 44;
static NSInteger const kTableViewWidth						= 320;
static NSInteger const kTableViewHeight						= 200;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInvitePeopleViewController

@synthesize searchContactsTextField         = _searchContactsTextField;
@synthesize topShadowView                   = _topShadowView;
@synthesize messageLabel                    = _messageLabel;
@synthesize spinnerContainerView            = _spinnerContainerView;

@synthesize navBarTitle                     = _navBarTitle;
@synthesize navBarSubTitle                  = _navBarSubTitle;
@synthesize inviteAlertText                 = _inviteAlertText;
@synthesize messageLabelText                = _messageLabelText;
@synthesize enforceInvite                   = _enforceInvite;
@synthesize teamSpecificInvite              = _teamSpecificInvite;
@synthesize showTopShadow                   = _showTopShadow;
@synthesize showBackButton                  = _showBackButton;
@synthesize showCancelButton                = _showCancelButton;
@synthesize addBackgroundView               = _addBackgroundView;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize spinnerOverlayView              = _spinnerOverlayView;

@synthesize queryContactsViewController     = _queryContactsViewController;
@synthesize addedContactsViewController     = _addedContactsViewController;

@synthesize delegate                        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.enforceInvite              = YES;
        self.teamSpecificInvite         = YES;
        self.inviteAlertText            = kMsgDefaultInviteAlertText;
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.searchContactsTextField        = nil;
    self.topShadowView                  = nil;
    self.messageLabel                   = nil;
    self.spinnerContainerView           = nil;
    
    self.navBarTitle                    = nil;
    self.navBarSubTitle                 = nil;
    self.inviteAlertText                = nil;
    self.messageLabelText               = nil;
    
    self.navTitleView                   = nil;
    self.navBarRightButtonView          = nil;
    self.spinnerOverlayView             = nil;
    
    self.queryContactsViewController    = nil;
    self.addedContactsViewController    = nil;    
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)freezeUI {	
    self.spinnerContainerView.hidden = NO;
    [self.spinnerOverlayView enable];
}

//----------------------------------------------------------------------------------------------------
- (void)unfreezeUI {
    self.spinnerContainerView.hidden = YES;
    [self.spinnerOverlayView disable];
}

//----------------------------------------------------------------------------------------------------
- (void)displayAddedContacts {
    self.queryContactsViewController.view.hidden    = YES;  
    self.addedContactsViewController.view.hidden    = NO;     
}

//----------------------------------------------------------------------------------------------------
- (void)displayQueriedContacts {
    self.queryContactsViewController.view.hidden    = NO;  
    self.addedContactsViewController.view.hidden    = YES;    
}

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];    
    
    [self.queryContactsViewController loadAllContacts];
    
    [pool release];    
}

//----------------------------------------------------------------------------------------------------
- (void)loadContacts:(NSString*)query {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [self.queryContactsViewController loadContactsMatching:[query stringByTrimmingCharactersInSet:
                                                            [NSCharacterSet whitespaceAndNewlineCharacterSet]]];    
    [pool release];
}

//----------------------------------------------------------------------------------------------------
- (void)displayInviteAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgErrorTitle
                                                    message:self.inviteAlertText
                                                   delegate:nil
                                          cancelButtonTitle:kMsgCancelTitle
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

//----------------------------------------------------------------------------------------------------
- (void)createInvites {
    
    if ([self.addedContactsViewController.tableView numberOfRowsInSection:0]) {
        
        [self freezeUI];
        [self.addedContactsViewController triggerInvites];            
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"invite_selected"];
    }
    else {
        if (self.enforceInvite) 
            [self displayInviteAlert];
        else
            [self.delegate inviteSkipped];
        
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)displayKeyboard {
    [self.searchContactsTextField becomeFirstResponder];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
            
    self.messageLabel.text = self.messageLabelText;
    
    if (self.addBackgroundView) 
        [self.view insertSubview:[DWGUIManager backgroundImageViewWithFrame:self.view.frame] 
                         atIndex:0];
        
    if (self.showBackButton) 
        self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    else 
        self.navigationItem.hidesBackButton     = YES;
    
    
    if (self.showCancelButton)
        self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarButtonWithImageName:kImgCancel
                                                                                   target:self
                                                                              andSelector:@selector(didTapCancelButton:)];
    if(self.showTopShadow)
        self.topShadowView.hidden = NO;
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    if (self.navBarSubTitle)
        [self.navTitleView displayTitle:self.navBarTitle 
                            andSubTitle:self.navBarSubTitle];    
    else
        [self.navTitleView displayTitle:self.navBarTitle];
    
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    
    if (!self.spinnerOverlayView)
        self.spinnerOverlayView = [[[DWSpinnerOverlayView alloc] initWithSpinnerOrigin:CGPointMake(109,154) 
                                                                          spinnerStyle:UIActivityIndicatorViewStyleWhite 
                                                                        andMessageText:kMsgProcessingText] autorelease];
        
    if (!self.queryContactsViewController) 
        self.queryContactsViewController = [[[DWContactsViewController alloc]
                                             initWithPresentationStyle:kPresentationStyleDefault] autorelease];
    
    if (!self.addedContactsViewController) 
        self.addedContactsViewController = [[[DWContactsViewController alloc]
                                             initWithPresentationStyle:kContactPresenterStyleSelected] autorelease];


    self.queryContactsViewController.delegate       = self;
    self.addedContactsViewController.delegate       = self;
           
    CGRect frame                                    = CGRectMake(kTableViewX,kTableViewY,kTableViewWidth,kTableViewHeight);    
    self.queryContactsViewController.view.frame     = frame;    
    self.addedContactsViewController.view.frame     = frame;

    [self.view addSubview:self.queryContactsViewController.view];    
    [self.view addSubview:self.addedContactsViewController.view];   
    
    
    if (!self.spinnerContainerView) 
        self.spinnerContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 480)] autorelease];
    
    self.spinnerContainerView.hidden            = YES;
    self.spinnerContainerView.backgroundColor   = [UIColor colorWithRed:0.0 
                                                                  green:0.0 
                                                                   blue:0.0 
                                                                  alpha:0.8];
    [self.view addSubview:self.spinnerContainerView];   
    
    
    [self displayQueriedContacts];
    [self performSelectorInBackground:@selector(loadAllContacts) 
                           withObject:nil];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:kActionNameForLoad];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender {
    
    self.messageLabel.hidden = YES;
    
    if ([self.searchContactsTextField.text length]) {        
        [self displayQueriedContacts];    
        [self performSelectorInBackground:@selector(loadContacts:) 
                               withObject:self.searchContactsTextField.text];
    }
    else {
        [self displayAddedContacts];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self createInvites];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapCancelButton:(UIButton*)button {  
    [self.navigationController popViewControllerAnimated:NO];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
	if(textField == self.searchContactsTextField)
        [self createInvites];
    
	return YES;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)contactSelected:(DWContact*)contact fromObject:(id)object {
    if ([object isEqual:self.queryContactsViewController ] ) {
        [self displayAddedContacts];
        [self.addedContactsViewController addContact:contact];
        [self.queryContactsViewController removeContactFromCache:contact];
        
        self.searchContactsTextField.text = kEmptyString;   
        
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"contact_selected_for_invite"
                                                                   andExtraInfo:[contact debugString]];
    }
    else {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"contact_selected_for_deletion"
                                                                   andExtraInfo:[contact debugString]];
        
        [self.addedContactsViewController showActionSheetInView:self.parentViewController.view
                                                    forRemoving:contact];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)allContactsLoaded {
    [self performSelectorOnMainThread:@selector(unfreezeUI) 
                           withObject:nil 
                        waitUntilDone:NO];
    
    [self performSelectorOnMainThread:@selector(displayKeyboard) 
                           withObject:nil 
                        waitUntilDone:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)contactRemoved:(DWContact*)contact {
    [self.queryContactsViewController addContactToCache:contact];
}


//----------------------------------------------------------------------------------------------------
- (void)invitesTriggeredFromObject:(id)object {
    
    if ([object isEqual:self.addedContactsViewController]) {
        
        [self unfreezeUI];
        
        if (self.teamSpecificInvite) 
            [self.delegate peopleInvitedToATeam];
        else
            [self.delegate peopleInvited];        
    }
}

//----------------------------------------------------------------------------------------------------
- (void)invitesTriggerErrorFromObject:(id)object {
    
    if ([object isEqual:self.addedContactsViewController]) {
        [self unfreezeUI];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)resendInvites {
    [self createInvites];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.spinnerOverlayView];
}

@end
