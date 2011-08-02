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
#import "DWNavBarFillerView.h"


static NSString* const kAddPeopleText                       = @"Add People";
static NSString* const kAddPeopleSubText                    = @"to the %@ Team";
static NSString* const kNavBarRightButtonText               = @"Done";
static NSInteger const kTableViewX							= 0;
static NSInteger const kTableViewY							= 44;
static NSInteger const kTableViewWidth						= 320;
static NSInteger const kTableViewHeight						= 200;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInvitePeopleViewController

@synthesize searchContactsTextField         = _searchContactsTextField;
@synthesize resultsLabel                    = _resultsLabel;

@synthesize teamName                        = _teamName;

@synthesize navTitleView                    = _navTitleView;
@synthesize navBarRightButtonView           = _navBarRightButtonView;
@synthesize navBarFillerView                = _navBarFillerView;

@synthesize queryContactsViewController     = _queryContactsViewController;
@synthesize addedContactsViewController     = _addedContactsViewController;

@synthesize delegate                        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
        //custom initialization
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.searchContactsTextField        = nil;
    self.resultsLabel                   = nil;
    
    self.teamName                       = nil;
    
    self.navTitleView                   = nil;
    self.navBarRightButtonView          = nil;
    self.navBarFillerView               = nil;
    
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
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    if (!self.navBarFillerView) 
        self.navBarFillerView = [[[DWNavBarFillerView alloc] 
                                  initWithFrame:CGRectMake(0, 0, 
                                                           kNavRightButtonWidth, 
                                                           kNavRightButtonHeight)] autorelease];
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                                andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kAddPeopleText 
                        andSubTitle:[NSString stringWithFormat:kAddPeopleSubText,self.teamName]];    
    
    if (!self.navBarRightButtonView)
        self.navBarRightButtonView = [[[DWNavBarRightButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavRightButtonWidth,
                                                                kNavRightButtonHeight)
                                               title:kNavBarRightButtonText 
                                           andTarget:self] autorelease];
    
    

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
    
    [self.searchContactsTextField becomeFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions

//----------------------------------------------------------------------------------------------------
- (IBAction)searchContactsTextFieldEditingChanged:(id)sender {
    
    if ([self.searchContactsTextField.text length]) {        
        [self displayQueriedContacts];        
        [self.queryContactsViewController 
         loadContactsMatching:[self.searchContactsTextField.text 
                               stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else {
        [self displayAddedContacts];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)didTapNavBarRightButton:(id)sender event:(id)event {
    [self.addedContactsViewController triggerInvites];
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
        
        self.searchContactsTextField.text = kEmptyString;        
    }
    else {
        [self.addedContactsViewController showActionSheetInView:self.parentViewController.view
                                                    forRemoving:contact];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)invitesTriggeredFromObject:(id)object {
    
    if ([object isEqual:self.addedContactsViewController]) 
        [self.delegate peopleInvited];
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
    [self.navigationController.navigationBar addSubview:self.navBarRightButtonView];
    [self.navigationController.navigationBar addSubview:self.navBarFillerView];    
}

@end
