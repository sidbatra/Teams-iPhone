//
//  DWAnalyticsManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWInteractionsController.h"


static NSString* const kActionNameForLoad   = @"load";

/**
 * Interface to store interactions locally and push to the
 * server when appropiate
 */
@interface DWAnalyticsManager : NSObject<DWInteractionsControllerDelegate> {
    
    NSMutableArray              *_interactions;
    DWInteractionsController    *_interactionsController;
}

/**
 * Shared sole instance of the class
 */
+ (DWAnalyticsManager *)sharedDWAnalyticsManager;


/**
 * Array of interaction model objects performed by the current user that haven't
 * yet been successfully uploaded to the server
 */
@property (nonatomic,retain) NSMutableArray *interactions;

/**
 * Interface to the interactions service
 */
@property (nonatomic,retain) DWInteractionsController  *interactionsController;


/**
 * Create an interaction via an action in the given view. The view can
 * have an id and extra info about the action
 */
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName
                      withViewID:(NSInteger)viewID
                    andExtraInfo:(NSString*)extra;

/**
 * Overloaded method for createInteractionForView. 
 * Default viewID is applied.
 */
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName
                    andExtraInfo:(NSString*)extra;

/**
 * Overloaded method for createInteractionForView.
 * Default extra info is applied.
 */
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName
                      withViewID:(NSInteger)viewID;

/**
 * Overloaded method for createInteractionForView. 
 * Default viewID and extra info is applied
 */
- (void)createInteractionForView:(NSObject*)view
                  withActionName:(NSString*)actionName;

@end
