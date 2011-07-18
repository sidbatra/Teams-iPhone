//
//  DWTableViewDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewDataSource.h"
#import "DWConstants.h"

static NSInteger const kDefaultSections = 1;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewDataSource

@synthesize objects     = _objects;
@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.objects = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(paginationCellReached:) 
													 name:kNPaginationCellReached
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)clean {
    SEL destroySelector = @selector(destroy);
    
    for(id object in self.objects) {
        if([object respondsToSelector:destroySelector])
            [object performSelector:destroySelector];
    }
    
    self.objects = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self clean];
    
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

//----------------------------------------------------------------------------------------------------
- (NSInteger)indexForObject:(id)object {
    return [self.objects indexOfObject:object];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    
}

//----------------------------------------------------------------------------------------------------
- (void)paginate {
}

//----------------------------------------------------------------------------------------------------
- (void)addObject:(id)object 
          atIndex:(NSInteger)index {
    
    [self.objects insertObject:object
                       atIndex:index];
    
    [self.delegate insertRowAtIndex:index];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)paginationCellReached:(NSNotification*)notification {
    if([notification object] == self) {
        [self paginate];
    }
}

@end
