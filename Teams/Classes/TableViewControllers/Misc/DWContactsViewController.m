//
//  DWContactsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsViewController.h"
#import "NSObject+Helpers.h"
#import "DWContact.h"
#import "DWAnalyticsManager.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsViewController

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
    
    self.view.hidden            = YES;
    self.view.backgroundColor   = [UIColor clearColor];
    
    [self disablePullToRefresh];
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
- (void)loadContactsMatching:(NSString *)string {
    [self.contactsDataSource loadContactsMatching:string];
}

//----------------------------------------------------------------------------------------------------
- (void)addContact:(DWContact *)contact {
    [self.contactsDataSource addContact:contact];
}

//----------------------------------------------------------------------------------------------------
- (void)triggerInvites {
    [self.contactsDataSource triggerInvites];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ActionSheet Methods

//----------------------------------------------------------------------------------------------------
- (void)showActionSheetInView:(UIView*)view forRemoving:(DWContact*)contact {
    _contactToRemove  = contact;
    
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
        
        [self.contactsDataSource removeContact:_contactToRemove];
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
- (void)invitesCreated {
    [self.delegate invitesTriggeredFromObject:self];
}

//----------------------------------------------------------------------------------------------------
- (void)contactsLoaded {
    [self performSelectorOnMainThread:@selector(reloadTableView) 
                           withObject:nil 
                        waitUntilDone:NO];
}


@end
