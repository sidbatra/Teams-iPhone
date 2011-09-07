//
//  DWInvitesController.h
//  Copyright 2011 Denwen. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol DWInvitesControllerDelegate;


/**
 * Interface to the invites service on the app server
 */
@interface DWInvitesController : NSObject {
    
    id <DWInvitesControllerDelegate,NSObject>  _delegate;
}

/**
 * Delegate recieves events based on the DWInvitesControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWInvitesControllerDelegate,NSObject> delegate;

/**
 * Create invites from the contacts user has selected and an optional teamID
 */
- (void)createInvitesFrom:(NSArray*)contacts 
                andTeamID:(NSInteger)teamID;
@end


/**
 * Protocol for the InvitesController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWInvitesControllerDelegate

/**
 * Fired when invites are created
 */
- (void)invitesCreated;

/**
 * Error message while creating invites
 */
- (void)invitesCreationError:(NSString*)error;

@end