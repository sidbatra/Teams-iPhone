//
//  DWContactsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsViewController.h"
#import "NSObject+Helpers.h"
#import "DWContact.h"
#import "DWLoadingView.h"
#import "DWErrorView.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsViewController

@synthesize contactToRemove             = _contactToRemove;
@synthesize contactsDataSource          = _contactsDataSource;

@synthesize delegate                    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithPresentationStyle:(NSInteger)style {
    self = [super init];
    
    if(self) {        
        self.contactsDataSource     = [[[DWContactsDataSource alloc] init] autorelease];
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:style]
                                        forKey:[[DWContact class] className]];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.contactToRemove    = nil;
    self.contactsDataSource = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecyle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];

    self.loadingView.hidden     = YES;    
    self.view.backgroundColor   = [UIColor clearColor];
    
    [self disablePullToRefresh];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)getTableLoadingView {
    return [[[DWLoadingView alloc] initWithFrame:CGRectMake(0,0,320,153)] autorelease];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)getTableErrorView {
    DWErrorView *errorView  = [[[DWErrorView alloc] initWithFrame:CGRectMake(0,0,320,153)] autorelease];
    errorView.delegate      = self;
    
    return errorView;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Datasource Methods


//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.contactsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)loadAllContacts {
    self.loadingView.hidden = NO;    
    [self.contactsDataSource loadAllContacts];
}

//----------------------------------------------------------------------------------------------------
- (void)loadContactsMatching:(NSString *)string {
    [self.contactsDataSource loadContactsMatching:string];
}

//----------------------------------------------------------------------------------------------------
- (void)addContact:(DWContact *)contact {
    [self.contactsDataSource addContact:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)removeContact:(DWContact *)contact {
    [self.contactsDataSource removeContact:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)addContactToCache:(DWContact *)contact {
    [self.contactsDataSource addContactToCache:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)removeContactFromCache:(DWContact *)contact {
    [self.contactsDataSource removeContactFromCache:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)triggerInvites {
    self.errorView.hidden = YES;
    [self.contactsDataSource triggerInvites];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ActionSheet Methods

//----------------------------------------------------------------------------------------------------
- (void)showActionSheetInView:(UIView*)view forRemoving:(DWContact*)contact {
    self.contactToRemove = contact;
    
    UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self 
                                                     cancelButtonTitle:kMsgActionSheetCancel
                                                destructiveButtonTitle:kMsgActionSheetDelete
                                                     otherButtonTitles:nil];
    
    [actionSheet showInView:view];
    [actionSheet release];
}

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (buttonIndex == 0) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"contact_deleted"];
        
        [self.contactsDataSource removeContact:self.contactToRemove];
        [self.delegate contactRemoved:self.contactToRemove];
    }
    else if(buttonIndex == 1) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"contact_deletion_cancelled"];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactPresenterDelegate (Implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)contactClicked:(id)contact {
    [self.delegate contactSelected:contact fromObject:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWContactDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)allContactsLoaded {
    self.loadingView.hidden = YES;
    [self.delegate allContactsLoaded];
}

//----------------------------------------------------------------------------------------------------
- (void)contactsLoadedFromQuery {
    [self performSelectorOnMainThread:@selector(reloadTableView) 
                           withObject:nil 
                        waitUntilDone:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreated {
    [self.delegate invitesTriggeredFromObject:self];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreationError:(NSString*)error {    
    [self displayError:error withRefreshUI:YES];
    [self.delegate invitesTriggerErrorFromObject:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Error view delegate

//----------------------------------------------------------------------------------------------------
- (void)errorViewTouched {
    self.errorView.hidden = YES;    
    [self.delegate resendInvites];
}

@end
