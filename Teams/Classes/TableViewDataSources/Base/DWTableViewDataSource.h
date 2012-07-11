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
    
    id<DWTableViewDataSourceDelegate,NSObject> __unsafe_unretained _delegate;
}

/**
 * Holds objects that correspond to the rows of a table view controller
 */
@property (nonatomic) NSMutableArray *objects;

/**
 * Delegate for communicating with the table view
 */
@property (nonatomic,unsafe_unretained) id<DWTableViewDataSourceDelegate,NSObject> delegate;


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

/**
 * Returns the index in the objects array for the given object. NSNotFound if not found.
 */
- (NSInteger)indexForObject:(id)object;

/**
 * Fired when a user generated or automated refresh is initiated
 */
- (void)refreshInitiated;

@end


/**
 * Select private methods and properties
 */
@interface DWTableViewDataSource()

/**
 * Destroy and release all objects
 */
- (void)clean;

/**
 * Load the next page of objects
 */
- (void)paginate;

/**
 * Add the given object into the given index
 * and instruct table view to display it with animation
 */
- (void)addObject:(id)object
          atIndex:(NSInteger)index;

/**
 * Add the given object at the end of the array
 */
- (void)addObjectAtEnd:(id)object;

/**
 * Remove the given object from the array with default 
 * animation
 */
- (void)removeObject:(id)object;

/**
 * Remove the given object from the array with specified 
 * animation
 */
- (void)removeObject:(id)object 
       withAnimation:(UITableViewRowAnimation)animation;

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

/**
 * Display an error message with the refresh UI
 */
- (void)displayError:(NSString*)message;

/**
 * Display an error message and control display of refresh UI
 */
- (void)displayError:(NSString*)message 
       withRefreshUI:(BOOL)showRefreshUI;

/**
 * Inserts a new row into the table view
 * with animation
 */
- (void)insertRowAtIndex:(NSInteger)index;

/**
 * Removes an existing row from the table view
 * with specified animation
 */
- (void)removeRowAtIndex:(NSInteger)index 
           withAnimation:(UITableViewRowAnimation)animation;

/**
 * Reload the cell at the given index
 */
- (void)reloadRowAtIndex:(NSInteger)index;

@end
