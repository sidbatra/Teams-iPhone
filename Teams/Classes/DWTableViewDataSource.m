//
//  DWTableViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewDataSource.h"

static NSInteger const kDefaultSections     = 1;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewDataSource

@synthesize objects    = _objects;

//----------------------------------------------------------------------------------------------------
- (NSInteger)getTotalSections {
    return kDefaultSections;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)getTotalObjectsForSection:(NSInteger)section {
    return [_objects count];
}

//----------------------------------------------------------------------------------------------------
- (NSObject*)getObjectAtIndex:(NSInteger)index 
                   forSection:(NSInteger)section {
    
    return index < [_objects count] ? [_objects objectAtIndex:index] : nil;
}

@end
