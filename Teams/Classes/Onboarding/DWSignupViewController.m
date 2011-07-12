//
//  DWSignupViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSignupViewController.h"
#import "DWGUIManager.h"
#import "DWConstants.h"
#import "DWRequestsManager.h"
#import "NSString+Helpers.h"

static NSString* const kSignupText                      = @"Sign Up";
static NSString* const kRightNavBarButtonText           = @"Next";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSignupViewController

@synthesize emailTextField              = _emailTextField;

@synthesize navTitleView                = _navTitleView;
@synthesize navRightBarButtonView       = _navRightBarButtonView;


//----------------------------------------------------------------------------------------------------
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        
        _delegate = theDelegate;
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreated:) 
													 name:kNNewUserCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userError:) 
													 name:kNNewUserError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamLoaded:) 
													 name:kNTeamLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamError:) 
													 name:kNTeamError
												   object:nil];	*/
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.emailTextField             = nil;
    
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.leftBarButtonItem   =   [DWGUIManager customBackButton:_delegate];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kSignupText];
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
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
//----------------------------------------------------------------------------------------------------
- (void)createNewUser {	
    /*
	if (self.emailTextField.text.length == 0) {        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMsgIncompleteTitle
														message:kMsgIncomplete
													   delegate:nil 
											  cancelButtonTitle:kMsgCancelTitle
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	else {			
        //TODO Freeze UI and show a spinner in workEmail
        //TODO Random generator for the password
        
        NSString *password = [[@"password" encrypt] stringByEncodingHTMLCharacters];        
        [[DWRequestsManager sharedDWRequestsManager] createUserWithEmail:self.emailTextField.text
                                                             andPassword:password];
	}*/
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark IBActions
//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {    
    [_delegate teamInfoRetrieved];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications
//----------------------------------------------------------------------------------------------------
- (void)userCreated:(NSNotification*)notification {
    /*NSString *domain = [self.emailTextField.text substringFromIndex:[self.emailTextField.text 
                                                                         rangeOfString:@"@"].location + 1];*/
    
    //Logic for joining/creating a team after the user has been created
}

//----------------------------------------------------------------------------------------------------
- (void)userError:(NSNotification*)notification {
    //unfreeze the UI
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(NSNotification*)notification {
    //[_delegate teamInformationRetrieved];
}

- (void)teamError:(NSNotification*)notification {
    //unfreeze the UI
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];    
    [self.navigationController.navigationBar addSubview:self.navRightBarButtonView];
}

@end
