//
//  DWTableViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewDataSource.h"

static NSInteger const kDefaultSections = 1;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewDataSource

@synthesize objects    = _objects;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.objects = [NSMutableArray array];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    SEL destroySelector = @selector(destroy);
    
    for(id object in self.objects) {
        if([object respondsToSelector:destroySelector])
            [object performSelector:destroySelector];
    }
    
    self.objects = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)totalSections {
    return kDefaultSections;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)totalObjectsForSection:(NSInteger)section {
    return [self.objects count];
}

//----------------------------------------------------------------------------------------------------
- (id)objectAtIndex:(NSInteger)index 
         forSection:(NSInteger)section {
    
    return index < [self.objects count] ? [self.objects objectAtIndex:index] : nil;
}

@end
