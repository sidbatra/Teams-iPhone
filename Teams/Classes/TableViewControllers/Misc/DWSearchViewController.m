//
//  DWSearchViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchViewController.h"
#import "DWUsersLogicController.h"
#import "DWTeamsLogicController.h"

#import "DWSearchDataSource.h"
#import "DWUser.h"
#import "DWTeam.h"
#import "NSObject+Helpers.h"


static NSString* const kSearchBarText				= @"Search places worldwide";
static NSString* const kSearchBarBackgroundClass	= @"UISearchBarBackground";
static NSInteger const kMinimumQueryLength			= 1;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchViewController

@synthesize usersLogicController    = _usersLogicController;
@synthesize teamsLogicController    = _teamsLogicController;
@synthesize searchDataSource        = _searchDataSource;
@synthesize searchBar               = _searchBar;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.usersLogicController       = [[[DWUsersLogicController alloc] init] autorelease];
        self.usersLogicController.tableViewController = self;
        
        self.teamsLogicController       = [[[DWTeamsLogicController alloc] init] autorelease];
        self.teamsLogicController.tableViewController = self;
        
        self.searchDataSource           = [[[DWSearchDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.usersLogicController       = nil;
    self.teamsLogicController       = nil;
    self.searchDataSource           = nil;
    self.searchBar                  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate {
    self.usersLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate {
    self.teamsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.searchDataSource;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWTeam class] className]])
        delegate = self.teamsLogicController;
    else if([className isEqualToString:[[DWUser class] className]])
        delegate = self.usersLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UISearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	if(theSearchBar.text.length >= kMinimumQueryLength) {
		
		[self.searchBar resignFirstResponder];
		
		[self.searchDataSource loadDataForQuery:theSearchBar.text];
	}
	
}

//----------------------------------------------------------------------------------------------------
- (void)searchBar:(UISearchBar *)searchBar
	textDidChange:(NSString *)searchText {
	
	if([searchText isEqualToString:kEmptyString]) {
	}
}



@end
