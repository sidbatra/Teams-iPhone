//
//  DWUsersController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWUser;
@protocol DWUsersControllerDelegate;


/**
 * Interface to Users Service on the app server
 */
@interface DWUsersController : NSObject {
    
    id<DWUsersControllerDelegate,NSObject>     _delegate;
}

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWUsersControllerDelegate,NSObject> delegate;

/**
 * Create a new user
 */
- (void)createUserWithEmail:(NSString*)email
                andPassword:(NSString*)password;
/**
 * Update the user's email during onboarding
 */
- (void)updateUserHavingID:(NSInteger)userID 
                 withEmail:(NSString*)email;

/**
 * Update the user's image and facebook token
 * during onboarding.
 */
- (void)updateUserHavingID:(NSInteger)userID
              withFilename:(NSString*)filename 
          andFacebookToken:(NSString*)facebookToken;

/**
 * Update the user's detail during onboarding
 */
- (void)updateUserHavingID:(NSInteger)userID 
             withFirstName:(NSString*)firstName 
                  lastName:(NSString*)lastName  
                    byline:(NSString*)byline 
               andPassword:(NSString*)password;

/**
 * Update the user details and profile picture
 * in the logged in edit user profile view
 */
- (void)updateUserHavingID:(NSInteger)userID 
             withFirstName:(NSString*)firstName 
                  lastName:(NSString*)lastName
                    byline:(NSString*)byline
               andFilename:(NSString*)filename;

/**
 * Update the iphone device id for the given userID
 */
- (void)updateUserHavingID:(NSInteger)userID
        withiPhoneDeviceID:(NSString*)deviceID;

/**
 * Update the unread notifications count for the give userID
 */
- (void)updateUserHavingID:(NSInteger)userID
    withNotificationsCount:(NSInteger)unreadNotificationsCount;

/**
 * Update the facebook token of the given user ID
 */
- (void)updateUserHavingID:(NSInteger)userID 
         withFacebookToken:(NSString*)facebookToken;

/**
 * Update the twitter token and secret of the given user ID
 */
- (void)updateUserHavingID:(NSInteger)userID 
          withTwitterToken:(NSString*)twitterToken
          andTwitterSecret:(NSString*)twitterSecret;

/**
 * Get the user with the given userID
 */
- (void)getUserWithID:(NSInteger)userID;

/**
 * Get all the followers of the given teamID
 */
- (void)getFollowersOfTeam:(NSInteger)teamID;

/**
 * Get the last follower of the given teamID
 */
- (void)getLastFollowerOfTeam:(NSInteger)teamID;

/**
 * Get all the members of the given teamID
 */
- (void)getMembersOfTeam:(NSInteger)teamID;

/**
 * Get the last member of the given teamID
 */
- (void)getLastMemberOfTeam:(NSInteger)teamID;

/**
 * Get users who've touched the given itemID
 */
- (void)getTouchersOfItem:(NSInteger)itemID;

@end


/**
 * Protocol for the UserController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWUsersControllerDelegate

@optional

/**
 * Used for pinging delegates of the objects waiting for the right resourceID
 */
- (NSInteger)usersResourceID;

/**
 * Fired when a user is created
 */
- (void)userCreated:(DWUser*)user;

/**
 * Error message while creating a user
 */
- (void)userCreationError:(NSString*)error;

/**
 * Fired when a user is updated
 */
- (void)userUpdated:(DWUser*)user;

/**
 * Error message while updating a user
 */
- (void)userUpdateError:(NSString*)error;

/**
 * Fired when a user object is successfully loaded
 */
- (void)userLoaded:(DWUser*)user;

/**
 * Fired when there is an error loading a user
 */
- (void)userLoadError:(NSString*)error;

/**
 * Array of parsed DWUser objects following a team
 */
- (void)teamFollowersLoaded:(NSMutableArray*)users;

/**
 * Error message while loading users following a team
 */
- (void)teamFollowersError:(NSString*)error;

/**
 * Array of parsed DWUser objects belonging to a team
 */
- (void)teamMembersLoaded:(NSMutableArray*)users;

/**
 * Error message while loading users belonging a team
 */
- (void)teamMembersError:(NSString*)error;

/**
 * Array of parsed DWUser objects who touched an item
 */
- (void)itemTouchersLoaded:(NSMutableArray*)users;

/**
 * Error message while loading users who touched an item
 */
- (void)itemTouchersError:(NSString*)error;

@end
