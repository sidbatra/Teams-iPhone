//
//  DWSearchDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchDataSource.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchDataSource

@synthesize searchController    = _searchController;
@synthesize query               = _query;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.searchController            = [[[DWSearchController alloc] init] autorelease];
        self.searchController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.searchController   = nil;
    self.query              = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadDataForQuery:(NSString*)query {
    self.query  = query;
    [self.searchController getSearchResultsForQuery:query];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadDataForQuery:self.query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSearchControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchLoaded:(NSMutableArray*)results {
    [self clean];
    self.objects = results;
    
    [self.delegate reloadTableView];
}

//----------------------------------------------------------------------------------------------------
- (void)searchLoadError:(NSString*)error {
    NSLog(@"Search error - %@",error);
    [self.delegate displayError:error];
}

@end




