//
//  DWInteractionsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWInteractionsControllerDelegate;

/**
 * Interface to the interactions service on the app server
 */
@interface DWInteractionsController : NSObject {
    
    id<DWInteractionsControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate receives events based on the DWInteractionsControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWInteractionsControllerDelegate,NSObject> delegate;


/**
 * Post new interactions. interactionsJSON is a JSON representation of of an array 
 * of interactions.
 */
- (void)postInteractions:(NSString*)interactionsJSON;

@end


/**
 * Protocol for delegates of DWInteractionsController instances
 */
@protocol DWInteractionsControllerDelegate

@optional

/**
 * Interactions successfully created along with the total number of interactions created
 */
- (void)interactionsCreated:(NSInteger)count;

/**
 * Error creating interactions
 */
- (void)interactionsCreationError:(NSString*)error;

@end