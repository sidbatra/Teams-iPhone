//
//  DWPoolObject.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * PoolObject is a mandatory base class for all
 * models that are added to the memory pool
 */
@interface DWPoolObject : NSObject {
	NSInteger	_databaseID;
	NSInteger	_pointerCount;
}

/**
 * Factory method for creating DWPoolObjects
 */
+ (id)create:(NSDictionary *)objectJSON;


/**
 * Primary key / unique id to uniquely identify the object
 */
@property (nonatomic,assign) NSInteger databaseID;


/**
 * Mount a pool object onto to the memory pool if the memory allocation
 * wasn't done via the pool
 */
- (void)mount;

/**
 * Stub method overriden by the children classes
 * to update their contents via a JSON dictionary
 */
- (void)update:(NSDictionary*)objectJSON;

/**
 * Stub method overriden by the children classes to free
 * any non critical memory
 */
- (void)freeMemory;

/**
 * Decreases the pointer count and releases the object if
 * there are no more references left
 */
- (void)destroy;

@end