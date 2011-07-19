//
//  DWInvitePeopleViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInvitePeopleViewController.h"
#import "ABContactsHelper.h"
#import "DWConstants.h"
#import "DWGUIManager.h"
#import "DWContact.h"

static NSString* const kAddPeopleText           = @"Add People";
static NSString* const kAddPeopleSubText        = @"to the %@ Team";
static NSString* const kRightNavBarButtonText   = @"Done";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInvitePeopleViewController

@synthesize searchContactsTextField         = _searchContactsTextField;
@synthesize resultsLabel                    = _resultsLabel;

@synthesize navTitleView                    = _navTitleView;
@synthesize navRightBarButtonView           = _navRightBarButtonView;

@synthesize contactsViewController          = _contactsViewController;

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
    self.searchContactsTextField    = nil;
    self.resultsLabel               = nil;
    
    self.navTitleView               = nil;
    self.navRightBarButtonView      = nil;    
    
    self.contactsViewController     = nil;
    
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
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager customBackButton:self.delegate];
    
    if (!self.navTitleView)
        self.navTitleView = [[[DWNavTitleView alloc] 
                              initWithFrame:CGRectMake(kNavTitleViewX,0,
                                                       kNavTitleViewWidth,
                                                       kNavTitleViewHeight) 
                              andDelegate:self] autorelease];
    
    [self.navTitleView displayTitle:kAddPeopleText 
                        andSubTitle:[NSString stringWithFormat:kAddPeopleSubText,@"Twitter"]];    
    
    if (!self.navRightBarButtonView)
        self.navRightBarButtonView = [[[DWNavRightBarButtonView alloc]
                                       initWithFrame:CGRectMake(260,0,
                                                                kNavTitleViewWidth,
                                                                kNavTitleViewHeight)
                                               title:kRightNavBarButtonText 
                                           andTarget:self] autorelease];
    
    CGRect frame                            = CGRectMake(0,100,320,320);    
    self.contactsViewController             = [[[DWContactsViewController alloc] init] autorelease];
    self.contactsViewController.view.frame  = frame;
    
    [self.view addSubview:self.contactsViewController.view];
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
    self.contactsViewController.view.hidden = NO;    
    [self.contactsViewController loadContactsMatching:self.searchContactsTextField.text];
}


//----------------------------------------------------------------------------------------------------
- (void)didTapDoneButton:(id)sender event:(id)event {
    [self.delegate peopleInvited];
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
