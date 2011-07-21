//
//  DWFollowingsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFollowingsController.h"
#import "DWFollowing.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"

static NSString* const kCreateFollowingURI      = @"/followings/teams/%d.json?";
static NSString* const kFollowingURI            = @"/followings/teams/%d/users/%d.json?";
static NSString* const kDestroyFollowingURI     = @"/followings/%d.json?";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFollowingsController

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingLoaded:) 
													 name:kNFollowingLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingLoadError:) 
													 name:kNFollowingError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingCreated:) 
													 name:kNNewFollowingCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingCreationError:) 
													 name:kNNewFollowingError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingDestroyed:) 
													 name:kNFollowingDestroyed
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(followingDestroyError:) 
													 name:kNFollowingDestroyError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"followings controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)postFollowingForTeamID:(NSInteger)teamID {
    
    NSString *localURL = [NSString stringWithFormat:kCreateFollowingURI,
                          teamID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewFollowingCreated
                                                   errorNotification:kNNewFollowingError
                                                       requestMethod:kPost
                                                          resourceID:teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show

//----------------------------------------------------------------------------------------------------
- (void)getFollowingForTeamID:(NSInteger)teamID 
                    andUserID:(NSInteger)userID {
    
    NSString *localURL = [NSString stringWithFormat:kFollowingURI,
                          teamID,
                          userID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNFollowingLoaded
                                                   errorNotification:kNFollowingError
                                                       requestMethod:kGet
                                                          resourceID:teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Destroy

//----------------------------------------------------------------------------------------------------
- (void)deleteFollowing:(NSInteger)followingID 
              forTeamID:(NSInteger)teamID {
    
    NSString *localURL = [NSString stringWithFormat:kDestroyFollowingURI,
                          followingID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNFollowingDestroyed
                                                   errorNotification:kNFollowingDestroyError
                                                       requestMethod:kDelete
                                                          resourceID:teamID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)followingLoaded:(NSNotification*)notification {
    
    SEL idSel           = @selector(followingResourceID);
    SEL followingSel    = @selector(followingLoaded:);
    
    if(![self.delegate respondsToSelector:followingSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSDictionary *data          = [userInfo objectForKey:kKeyData];
    DWFollowing *following      = nil;
    
    if(data && ![data isKindOfClass:[NSNull class]])
       following = [DWFollowing create:data];
    
    [self.delegate performSelector:followingSel
                        withObject:following];
}

//----------------------------------------------------------------------------------------------------
- (void)followingLoadError:(NSNotification*)notification {
    
    SEL idSel    = @selector(followingResourceID);
    SEL errorSel = @selector(followingLoadError:);
    
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
- (void)followingCreated:(NSNotification*)notification {
    
    SEL idSel           = @selector(followingResourceID);
    SEL followingSel    = @selector(followinCreated:);
    
    if(![self.delegate respondsToSelector:followingSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    NSDictionary *data          = [userInfo objectForKey:kKeyData];
    DWFollowing *following      = [DWFollowing create:data];
    
    [self.delegate performSelector:followingSel
                        withObject:following];
}

//----------------------------------------------------------------------------------------------------
- (void)followingCreationError:(NSNotification*)notification {
    
    SEL idSel    = @selector(followingResourceID);
    SEL errorSel = @selector(followingCreationError:);
    
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
- (void)followingDestroyed:(NSNotification*)notification {
    
    SEL idSel           = @selector(followingResourceID);
    SEL followingSel    = @selector(followingDestroyed:);
    
    if(![self.delegate respondsToSelector:followingSel] || ![self.delegate respondsToSelector:idSel])
        return;
    
    
    NSDictionary *userInfo  = [notification userInfo];
    NSInteger resourceID    = [[userInfo objectForKey:kKeyResourceID] integerValue];
    
    if(resourceID != (NSInteger)[self.delegate performSelector:idSel])
        return;
    
    
    [self.delegate performSelector:followingSel];
}

//----------------------------------------------------------------------------------------------------
- (void)followingDestroyError:(NSNotification*)notification {
    
    SEL idSel    = @selector(followingResourceID);
    SEL errorSel = @selector(followingDestroyError:);
    
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
