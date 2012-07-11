//
//  DWFollowingsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWFollowing;
@protocol DWFollowingsControllerDelegate;

/**
 * Interface to the followings service on the app server
 */
@interface DWFollowingsController : NSObject {
    
    id<DWFollowingsControllerDelegate,NSObject>  __unsafe_unretained _delegate;
}

/**
 * Received events based on the DWFollowingsControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWFollowingsControllerDelegate,NSObject> delegate;



/**
 * Create a following for current user and the given team id
 */
- (void)postFollowingForTeamID:(NSInteger)teamID;

/**
 * Get following between a user and a team. nil if none exists
 */
- (void)getFollowingForTeamID:(NSInteger)teamID 
                    andUserID:(NSInteger)userID;

/**
 * Delete the given followingID. Use teamID as resource identifier
 */
- (void)deleteFollowing:(NSInteger)followingID 
              forTeamID:(NSInteger)teamID;

@end


/**
 * Protocol for delegates of DWFollowingsController instances
 */
@protocol DWFollowingsControllerDelegate

@optional

/**
 * Resource ID to uniquely identify following requests
 */
- (NSInteger)followingResourceID;

/**
 * Following has been retrieved
 */
- (void)followingLoaded:(DWFollowing*)following;

/**
 * Error loading a following
 */
- (void)followingLoadError:(NSString*)error;

/**
 * New following is successfully created
 */
- (void)followingCreated:(DWFollowing*)following;

/**
 * Error creating new folloing
 */
- (void)followingCreationError:(NSString*)error;

/**
 * Following is successfully destroyed
 */
- (void)followingDestroyed;

/**
 * Error destroying a following
 */
- (void)followingDestroyError:(NSString*)error;

@end


