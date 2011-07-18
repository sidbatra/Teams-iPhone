//
//  DWMembershipsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWMembership;
@protocol DWMembershipsControllerDelegate;


/**
 * Interface to the touches service on the app server
 */
@interface DWMembershipsController : NSObject {
    
    id<DWMembershipsControllerDelegate,NSObject>     _delegate;
}


/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWMembershipsControllerDelegate,NSObject> delegate;

/**
 * Create membership for teamID
 */
- (void)createMembershipForTeamID:(NSInteger)teamID;

@end


/**
 * Protocol for the MembershipsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWMembershipsControllerDelegate

@optional

/**
 * Fired when a membership is created
 */
- (void)membershipCreated;

@end
