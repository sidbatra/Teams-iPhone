//
//  DWTableViewDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Data source for the DWTableViewController implementation.
 * Its child classes are responsible for storing and procuring
 * data for table view across the application.
 */
@interface DWTableViewDataSource : NSObject {
    NSMutableArray  *_objects;
}

/**
 * Holds objects that correspond to the rows of a table view controller
 */
@property (nonatomic,retain) NSMutableArray *objects;


/**
 * Get the total number of sections 
 */
- (NSInteger)getTotalSections;

/**
 * Fetch the total number of objects for the given section
 */
- (NSInteger)getTotalObjectsForSection:(NSInteger)section;

/**
 * Fetch the object at the given index
 */
- (NSObject*)getObjectAtIndex:(NSInteger)index 
                   forSection:(NSInteger)section;

@end
