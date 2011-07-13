//
//  DWTableViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPagination.h"

@protocol DWTableViewDataSourceDelegate;


/**
 * Data source for the DWTableViewController implementation.
 * Its child classes are responsible for storing and procuring
 * data for table view across the application.
 */
@interface DWTableViewDataSource : NSObject {
    NSMutableArray  *_objects;
    
    id<DWTableViewDataSourceDelegate> _delegate;
}

/**
 * Holds objects that correspond to the rows of a table view controller
 */
@property (nonatomic,retain) NSMutableArray *objects;

/**
 * Delegate for communicating with the table view
 */
@property (nonatomic,assign) id<DWTableViewDataSourceDelegate> delegate;


/**
 * Get the total number of sections 
 */
- (NSInteger)totalSections;

/**
 * Fetch the total number of objects for the given section
 */
- (NSInteger)totalObjectsForSection:(NSInteger)section;

/**
 * Fetch the object at the given index
 */
- (id)objectAtIndex:(NSInteger)index 
         forSection:(NSInteger)section;

@end


/**
 * Select private methods and properties
 */
@interface DWTableViewDataSource()

/**
 * Optionally destroy and release all objects
 */
- (void)clean;

@end


/**
 * DWTableViewDataSource delegate definition. It's used to communicate
 * with the table view controller for which its a data source
 */
@protocol DWTableViewDataSourceDelegate

/**
 * Request a full reload
 */
- (void)reloadTableView;
@end
