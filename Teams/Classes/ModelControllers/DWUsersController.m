//
//  DWUsersController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUsersController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWRequestHelper.h"
#import "DWUser.h"

static NSString* const kNewUserURI                          = @"/users.json?user[email]=%@&user[password]=%@";
static NSString* const kUpdateUserURI                       = @"/users/%d.json?user[email]=%@&user[first_name]=%@&user[last_name]=%@&user[byline]=%@&user[password]=%@&user[filename]=%@";

static NSString* const kUpdateUserEmailURI                  = @"/users/%d.json?user[email]=%@";
static NSString* const kUpdateUserImageAndFBTokenURI        = @"/users/%d.json?user[filename]=%@&user[facebook_token]=%@";
static NSString* const kUpdateUserDeviceURI                 = @"/users/%d.json?user[iphone_device_id]=%@";
static NSString* const kUpdateUserNotificationsCountURI     = @"/users/%d.json?user[unread_notifications_count]=%d";
static NSString* const kUpdateUserFacebookTokenURI          = @"/users/%d.json?user[facebook_token]=%@";
static NSString* const kUpdateUserTwitterTokenURI           = @"/users/%d.json?user[twitter_token]=%@&user[twitter_secret]=%@";
static NSString* const kUserURI                             = @"/users/%d.json?";
static NSString* const kTeamFollowersURI                    = @"/teams/%d/followers.json?limit=%d";
static NSString* const kTeamMembersURI                      = @"/teams/%d/members.json?limit=%d";
static NSString* const kItemTouchersURI                     = @"/items/%d/touchers.json?";


/**
 * Private method and property declarations
 */
@interface DWUsersController()

/**
 * Populate a mutable users array from the given users JSON array
 */
- (NSMutableArray*)populateUsersArrayFromJSON:(NSArray*)data;

/**
 * Get the followers of the given teamID limit to the given limit.
 * limit of 0 switches back to server based pagination
 */
- (void)getFollowersOfTeam:(NSInteger)teamID 
                 withLimit:(NSInteger)limit;

/**
 * Get the members of the given teamID limit to the given limit.
 * limit of 0 switches back to server based pagination
 */
- (void)getMembersOfTeam:(NSInteger)teamID 
               withLimit:(NSInteger)limit;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUsersController

@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreated:) 
													 name:kNNewUserCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userCreationError:) 
													 name:kNNewUserError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdated:) 
													 name:kNUserUpdated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userUpdateError:) 
													 name:kNUserUpdateError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userLoaded:) 
													 name:kNUserLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(userLoadError:) 
													 name:kNUserError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamFollowersLoaded:) 
													 name:kNTeamFollowersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamFollowersError:) 
													 name:kNTeamFollowersError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamMembersLoaded:) 
													 name:kNTeamMembersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamMembersError:) 
													 name:kNTeamMembersError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemTouchersLoaded:) 
													 name:kNItemTouchersLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(itemTouchersError:) 
													 name:kNItemTouchersError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Users controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createUserWithEmail:(NSString*)email andPassword:(NSString*)password {
    
    NSString *localURL = [NSString stringWithFormat:kNewUserURI,
                          [email stringByEncodingHTMLCharacters],
                          [password stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewUserCreated
                                                   errorNotification:kNNewUserError
                                                       requestMethod:kPost 
                                                        authenticate:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Update

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
                 withEmail:(NSString*)email
              andFirstName:(NSString*)firstName 
                  lastName:(NSString*)lastName
                    byline:(NSString*)byline
                  password:(NSString*)password 
               andFilename:(NSString*)filename 
              withCallBack:(BOOL)callback {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserURI,
                          userID,
                          [email stringByEncodingHTMLCharacters],
                          [firstName stringByEncodingHTMLCharacters],
                          [lastName stringByEncodingHTMLCharacters],
                          [byline stringByEncodingHTMLCharacters],
                          [password stringByEncodingHTMLCharacters],
                          [filename stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut 
                                                            callerID:callback ? self.hash : 0];
    
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
                 withEmail:(NSString*)email {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserEmailURI,
                          userID,
                          [email stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut 
                                                            callerID:self.hash];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID
              withFilename:(NSString *)filename 
          andFacebookToken:(NSString*)facebookToken {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserImageAndFBTokenURI,
                          userID,
                          [filename stringByEncodingHTMLCharacters],
                          [facebookToken stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut 
                                                            callerID:self.hash];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
             withFirstName:(NSString*)firstName 
                  lastName:(NSString*)lastName
                    byline:(NSString*)byline
               andPassword:(NSString*)password {
    
    [self updateUserHavingID:userID 
                   withEmail:kEmptyString 
                andFirstName:firstName 
                    lastName:lastName 
                      byline:byline     
                    password:password 
                 andFilename:kEmptyString 
                withCallBack:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
             withFirstName:(NSString*)firstName 
                  lastName:(NSString*)lastName
                    byline:(NSString*)byline
               andFilename:(NSString*)filename {
    
    [self updateUserHavingID:userID 
                   withEmail:kEmptyString 
                andFirstName:firstName 
                    lastName:lastName 
                      byline:byline     
                    password:kEmptyString 
                 andFilename:filename 
                withCallBack:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID
        withiPhoneDeviceID:(NSString*)deviceID {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserDeviceURI,
                          userID,
                          [deviceID stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut];    
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID
    withNotificationsCount:(NSInteger)unreadNotificationsCount {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserNotificationsCountURI,
                          userID,
                          unreadNotificationsCount];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut];    
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
         withFacebookToken:(NSString*)facebookToken {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserFacebookTokenURI,
                          userID,
                          [facebookToken stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut];
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserHavingID:(NSInteger)userID 
          withTwitterToken:(NSString*)twitterToken
          andTwitterSecret:(NSString*)twitterSecret {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateUserTwitterTokenURI,
                          userID,
                          [twitterToken stringByEncodingHTMLCharacters],
                          [twitterSecret stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserUpdated
                                                   errorNotification:kNUserUpdateError
                                                       requestMethod:kPut];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show

//----------------------------------------------------------------------------------------------------
- (void)getUserWithID:(NSInteger)userID {
    
    NSString *localURL = [NSString stringWithFormat:kUserURI,
                          userID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNUserLoaded
                                                   errorNotification:kNUserError
                                                       requestMethod:kGet
                                                          resourceID:userID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)populateUsersArrayFromJSON:(NSArray*)data {
    
    NSMutableArray *users   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *user in data) {
        [users addObject:[DWUser create:user]];
    }
    
    return users;
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowersOfTeam:(NSInteger)teamID 
                 withLimit:(NSInteger)limit {

    
    NSString *localURL = [NSString stringWithFormat:kTeamFollowersURI,teamID,limit];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamFollowersLoaded
                                                   errorNotification:kNTeamFollowersError
                                                       requestMethod:kGet
                                                          resourceID:teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)getFollowersOfTeam:(NSInteger)teamID {
    [self getFollowersOfTeam:teamID 
                   withLimit:0];
}

//----------------------------------------------------------------------------------------------------
- (void)getLastFollowerOfTeam:(NSInteger)teamID {
    [self getFollowersOfTeam:teamID 
                   withLimit:1];
}

//----------------------------------------------------------------------------------------------------
- (void)getMembersOfTeam:(NSInteger)teamID 
               withLimit:(NSInteger)limit {
 
    NSString *localURL = [NSString stringWithFormat:kTeamMembersURI,teamID,limit];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamMembersLoaded
                                                   errorNotification:kNTeamMembersError
                                                       requestMethod:kGet
                                                          resourceID:teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)getMembersOfTeam:(NSInteger)teamID {
    [self getMembersOfTeam:teamID 
                 withLimit:0];
}

//----------------------------------------------------------------------------------------------------
- (void)getLastMemberOfTeam:(NSInteger)teamID {
    [self getMembersOfTeam:teamID 
                 withLimit:1];
}

//----------------------------------------------------------------------------------------------------
- (void)getTouchersOfItem:(NSInteger)itemID {
    
    NSString *localURL = [NSString stringWithFormat:kItemTouchersURI,itemID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNItemTouchersLoaded
                                                   errorNotification:kNItemTouchersError
                                                       requestMethod:kGet
                                                          resourceID:itemID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userCreated:(NSNotification*)notification {
    
    SEL sel = @selector(userCreated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    
    NSArray *errors     = [data objectForKey:kKeyErrors];
    
    if ([errors count] ) {
        SEL sel = @selector(userCreationError:);
        
        if(![self.delegate respondsToSelector:sel])
            return;
        
        [self.delegate performSelector:sel 
                            withObject:[DWRequestHelper generateErrorMessageFrom:errors]];
        return;
    }
    
    DWUser *user    = [DWUser create:data];    
    [self.delegate performSelector:sel 
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(userCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdated:(NSNotification*)notification {
    
    NSDictionary *info      = [notification userInfo];
    NSUInteger callerID     = [[info objectForKey:kKeyCallerID] unsignedIntegerValue];
    
    if(callerID && callerID != self.hash)
        return;
    
    
    SEL sel = @selector(userUpdated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *data  = [info objectForKey:kKeyData];
    NSArray *errors     = [data objectForKey:kKeyErrors];
    
    if ([errors count] ) {
        SEL errorSel = @selector(userUpdateError:);
        
        if(![self.delegate respondsToSelector:errorSel])
            return;
        
        [self.delegate performSelector:errorSel 
                            withObject:[DWRequestHelper generateErrorMessageFrom:errors]];
        return;
    }
    
    DWUser *user    = [DWUser create:data]; 
    [self.delegate performSelector:sel 
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userUpdateError:(NSNotification*)notification {
    
    NSDictionary *info      = [notification userInfo];
    NSUInteger callerID     = [[info objectForKey:kKeyCallerID] unsignedIntegerValue];
    
    if(callerID && callerID != self.hash)
        return;

    
    SEL sel = @selector(userUpdateError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [info objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL usersSel = @selector(userLoaded:);
    
    if(![self.delegate respondsToSelector:usersSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSDictionary *data      = [userInfo objectForKey:kKeyData];
    DWUser *user            = [DWUser create:data];    
    
    [self.delegate performSelector:usersSel
                        withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)userLoadError:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL errorSel = @selector(userLoadError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}


//----------------------------------------------------------------------------------------------------
- (void)teamFollowersLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL usersSel = @selector(teamFollowersLoaded:);
    
    if(![self.delegate respondsToSelector:usersSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *users   = [self populateUsersArrayFromJSON:data];
    
    [self.delegate performSelector:usersSel
                        withObject:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamFollowersError:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL errorSel = @selector(teamFollowersError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL usersSel = @selector(teamMembersLoaded:);
    
    if(![self.delegate respondsToSelector:usersSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *users   = [self populateUsersArrayFromJSON:data];
    
    [self.delegate performSelector:usersSel
                        withObject:users];
}

//----------------------------------------------------------------------------------------------------
- (void)teamMembersError:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL errorSel = @selector(teamMembersError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)itemTouchersLoaded:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL usersSel = @selector(itemTouchersLoaded:);
    
    if(![self.delegate respondsToSelector:usersSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSArray *data           = [userInfo objectForKey:kKeyData];
    NSMutableArray *users   = [self populateUsersArrayFromJSON:data];
    
    [self.delegate performSelector:usersSel
                        withObject:users];
}

//----------------------------------------------------------------------------------------------------
- (void)itemTouchersError:(NSNotification*)notification {
    
    SEL idSel    = @selector(usersResourceID);
    SEL errorSel = @selector(itemTouchersError:);
    
    if(![self.delegate respondsToSelector:errorSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}

@end
