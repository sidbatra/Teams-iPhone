//
//  DWTeamsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTeam;
@protocol DWTeamsControllerDelegate;


/**
 * Interface to the teams service on the app server
 */
@interface DWTeamsController : NSObject {
    
    id<DWTeamsControllerDelegate,NSObject>     _delegate;
}

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWTeamsControllerDelegate,NSObject> delegate;

/**
 * Get information about a team from the domain
 */
- (void)getTeamFromDomain:(NSString*)domain;

@end


/**
 * Protocol for the TeamsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWTeamsControllerDelegate

@optional

/**
 * Fired when information for a team is loaded
 */
- (void)teamLoaded:(DWTeam*)team;

/**
 * Error message while loading a team
 */
- (void)teamLoadError:(NSString*)error;

@end