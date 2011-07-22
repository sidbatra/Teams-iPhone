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
- (void)getTeamFromDomain:(NSString*)domain 
            andResourceID:(NSInteger)resourceID;

/**
 * Get team details for the given teamID
 */
- (void)getTeamWithID:(NSInteger)teamID;

/**
 * Get a list of popular teams
 */
- (void)getPopularTeams;

/**
 * Get a list of recently created teams
 */
- (void)getRecentTeams;

/**
 * Create a new team
 */
- (void)createTeamWithName:(NSString*)name
                    byline:(NSString*)byline 
                 andDomain:(NSString*)domain;

/**
 * Update an existing team
 */
- (void)updateTeamHavingID:(NSInteger)teamID
                  withName:(NSString*)name
                    byline:(NSString*)byline 
                 andDomain:(NSString*)domain;

- (void)updateTeamHavingID:(NSInteger)teamID 
                  withName:(NSString*)name 
                 andByline:(NSString*)byline;

@end


/**
 * Protocol for the TeamsController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWTeamsControllerDelegate

@optional

/**
 * Used for pinging delegates of the object waiting for the right resourceID
 */
- (NSInteger)teamResourceID;

/**
 * Fired when information for a team is loaded
 */
- (void)teamLoaded:(DWTeam*)team;

/**
 * Error message while loading a team
 */
- (void)teamLoadError:(NSString*)error;

/**
 * Array of parsed DWTeam objects which are currently popular
 */
- (void)popularTeamsLoaded:(NSMutableArray*)teams;

/**
 * Error message encountered while loading popular teams
 */
- (void)popularTeamsError:(NSString*)message;

/**
 * Array of parsed DWTeam objects which have been recently created
 */
- (void)recentTeamsLoaded:(NSMutableArray*)teams;

/**
 * Error message encountered while loading recent teams
 */
- (void)recentTeamsError:(NSString*)message;

/**
 * Fired when a team is created
 */
- (void)teamCreated:(DWTeam*)team;

/**
 * Error message while creating a team
 */
- (void)teamCreationError:(NSString*)error;

/**
 * Fired when a team is updated
 */
- (void)teamUpdated:(DWTeam*)team;

/**
 * Error message while updating a team
 */
- (void)teamUpdateError:(NSString*)error;

@end
