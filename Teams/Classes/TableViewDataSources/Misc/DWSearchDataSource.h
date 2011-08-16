//
//  DWSearchDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewDataSource.h"
#import "DWSearchController.h"

@class DWResource;

/**
 * Data source for the search table view controller
 */
@interface DWSearchDataSource : DWTableViewDataSource<DWSearchControllerDelegate> {
    DWSearchController      *_searchController;
    
    DWResource              *_invite;
    
    NSString                *_query;
}

/**
 * Interface to the search service
 */ 
@property (nonatomic,retain) DWSearchController *searchController;

/**
 * Resource object representing the invite people cell
 */
@property (nonatomic,retain) DWResource *invite;

/**
 * The query for which search results are being fetched
 */
@property (nonatomic,copy) NSString *query;


/**
 * Start fetching search results from the server
 */
- (void)loadDataForQuery:(NSString*)query;

@end
