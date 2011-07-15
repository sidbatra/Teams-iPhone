//
//  DWPoolObject.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPoolObject.h"
#import "DWMemoryPool.h"
#import "NSObject+Helpers.h"
#import "DWConstants.h"

static NSString* const kMsgOverride = @"WARNING - Override method in child class of DWPoolObject";


/**
 * Private method and property declarations
 */
@interface DWPoolObject()

/**
 * Similar to retain count a count of the different places
 * the object is being used. An object is freed is the 
 * count drop below one
 */
@property (nonatomic,assign) NSInteger pointerCount;


/**
 * Returns the unique identifier for the object as a string
 */
- (NSString*)objectID;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPoolObject

@synthesize pointerCount	= _pointerCount;
@synthesize databaseID		= _databaseID;

//----------------------------------------------------------------------------------------------------
+ (id)create:(NSDictionary *)objectJSON {
    
    NSString* objectID      = [NSString stringWithFormat:@"%@",[objectJSON objectForKey:kKeyID]];
    DWPoolObject *object    = [[DWMemoryPool sharedDWMemoryPool] getObjectWithID:objectID
                                                                        forClass:[self className]];
    
    if(!object) {
        object = [[[self alloc] init] autorelease];
        [[DWMemoryPool sharedDWMemoryPool] setObject:object
                                              withID:objectID 
                                            forClass:[self className]];
    }
    
    object.pointerCount++;
    [object update:objectJSON];
    
    return object;
}

//----------------------------------------------------------------------------------------------------
+ (id)fetch:(NSInteger)objectID {
    return [[DWMemoryPool sharedDWMemoryPool] getObjectWithID:[NSString stringWithFormat:@"%d",objectID]
                                                     forClass:[self className]];
}

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		_pointerCount	= 0;
		_databaseID		= kMPDefaultDatabaseID;
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)destroy {

	if(--self.pointerCount <= 0) {
        [[DWMemoryPool sharedDWMemoryPool] removeObjectWithID:[self objectID]
                                                     forClass:[[self class] className]];
	}    
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)mount {
    [[DWMemoryPool sharedDWMemoryPool] setObject:self
                                          withID:[self objectID]
                                        forClass:[[self class] className]];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)objectID {
    return [NSString stringWithFormat:@"%d",self.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)objectJSON {
    self.databaseID = [[objectJSON objectForKey:kKeyID] integerValue];
}

@end
