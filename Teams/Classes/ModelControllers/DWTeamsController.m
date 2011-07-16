//
//  DWTeamsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWRequestHelper.h"
#import "DWTeam.h"


static NSString* const kTeamURI             = @"/teams/domain/%@.json?";
static NSString* const kTeamShowURI         = @"/teams/%d.json?";
static NSString* const kPopularTeamsURI     = @"/popular/teams.json?";
static NSString* const kRecentTeamsURI      = @"/recent/teams.json?";
static NSString* const kNewTeamURI			= @"/teams.json?team[name]=%@&team[byline]=%@&team[domain]=%@";
static NSString* const kUpdateTeamURI       = @"/teams/@%d.json?team[name]=%@&team[byline]=%@&team[domain]=%@";


/**
 * Private method and property declarations
 */
@interface DWTeamsController()

/**
 * Populate a mutable teams array from the given teams JSON array
 */
- (NSMutableArray*)populateTeamsArrayFromJSON:(NSArray*)data;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsController

@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamLoaded:) 
													 name:kNTeamLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamLoadError:) 
													 name:kNTeamLoadError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(popularTeamsLoaded:) 
													 name:kNPopularTeamsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(popularTeamsError:) 
													 name:kNPopularTeamsError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(recentTeamsLoaded:) 
													 name:kNRecentTeamsLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(recentTeamsError:) 
													 name:kNRecentTeamsError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamCreated:) 
													 name:kNNewTeamCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamCreationError:) 
													 name:kNNewTeamError
												   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamUpdated:) 
													 name:kNTeamUpdated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(teamUpdateError:) 
													 name:kNTeamUpdateError
												   object:nil];        
    }
    return self;
}



//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Teams controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Show

//----------------------------------------------------------------------------------------------------
- (void)getTeamFromDomain:(NSString*)domain {
    
    NSData *domainData  = [domain dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *localURL  = [NSString stringWithFormat:kTeamURI,
                           [[domainData base64Encoding] stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamLoaded
                                                   errorNotification:kNTeamLoadError
                                                       requestMethod:kGet];
}

//----------------------------------------------------------------------------------------------------
- (void)getTeamWithID:(NSInteger)teamID {
    
    NSString *localURL = [NSString stringWithFormat:kTeamShowURI,teamID];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamLoaded
                                                   errorNotification:kNTeamLoadError
                                                       requestMethod:kGet];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (NSMutableArray*)populateTeamsArrayFromJSON:(NSArray*)data {
    
    NSMutableArray *teams   = [NSMutableArray arrayWithCapacity:[data count]];
    
    for(NSDictionary *team in data) {
        [teams addObject:[DWTeam create:team]];
    }
    
    return teams;
}

//----------------------------------------------------------------------------------------------------
- (void)getPopularTeams {
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:kPopularTeamsURI
                                                 successNotification:kNPopularTeamsLoaded
                                                   errorNotification:kNPopularTeamsError
                                                       requestMethod:kGet];
}

//----------------------------------------------------------------------------------------------------
- (void)getRecentTeams {
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:kRecentTeamsURI
                                                 successNotification:kNRecentTeamsLoaded
                                                   errorNotification:kNRecentTeamsError
                                                       requestMethod:kGet];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createTeamWithName:(NSString*)name 
                    byline:(NSString*)byline
                 andDomain:(NSString *)domain {
    
    NSString *localURL = [NSString stringWithFormat:kNewTeamURI,
                          [name stringByEncodingHTMLCharacters],
                          [byline stringByEncodingHTMLCharacters],
                          [domain stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewTeamCreated
                                                   errorNotification:kNNewTeamError
                                                       requestMethod:kPost];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Update

//----------------------------------------------------------------------------------------------------
- (void)updateTeamHavingID:(NSInteger)teamID 
                  withName:(NSString*)name 
                    byline:(NSString*)byline
                 andDomain:(NSString *)domain {
    
    NSString *localURL = [NSString stringWithFormat:kUpdateTeamURI,
                          teamID,
                          [name stringByEncodingHTMLCharacters],
                          [byline stringByEncodingHTMLCharacters],
                          [domain stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNTeamUpdated
                                                   errorNotification:kNTeamUpdateError
                                                       requestMethod:kPut];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)teamLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(teamLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    
    DWTeam *team = nil;
    
    if (![data isKindOfClass:[NSNull class]]) 
        team = [DWTeam create:data];
    
    [self.delegate performSelector:sel 
                        withObject:team];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSNotification*)notification {
	
    SEL sel = @selector(teamLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)popularTeamsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(popularTeamsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSArray *data           = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *teams   = [self populateTeamsArrayFromJSON:data];
    
    [self.delegate performSelector:sel 
                        withObject:teams];
}

//----------------------------------------------------------------------------------------------------
- (void)popularTeamsError:(NSNotification*)notification {
    
    SEL sel = @selector(popularTeamsError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)recentTeamsLoaded:(NSNotification*)notification {
    
    SEL sel = @selector(recentTeamsLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSArray *data           = [[notification userInfo] objectForKey:kKeyData];
    NSMutableArray *teams   = [self populateTeamsArrayFromJSON:data];
    
    [self.delegate performSelector:sel 
                        withObject:teams];
}

//----------------------------------------------------------------------------------------------------
- (void)recentTeamsError:(NSNotification*)notification {
    
    SEL sel = @selector(recentTeamsError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)teamCreated:(NSNotification*)notification {
  
    SEL sel = @selector(teamCreated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    NSArray *errors     = [data objectForKey:kKeyErrors];
    
    if ([errors count]) {
        SEL errorSel = @selector(teamCreationError:);
        
        if(![self.delegate respondsToSelector:errorSel])
            return;
        
        [self.delegate performSelector:errorSel 
                            withObject:[DWRequestHelper generateErrorMessageFrom:errors]];
        return;
    }
    
    DWTeam *team = [DWTeam create:data]; 
    [self.delegate performSelector:sel 
                        withObject:team];
}

//----------------------------------------------------------------------------------------------------
- (void)teamCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(teamCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

//----------------------------------------------------------------------------------------------------
- (void)teamUpdated:(NSNotification*)notification {
    
    SEL sel = @selector(teamUpdated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    NSArray *errors     = [data objectForKey:kKeyErrors];
    
    if ([errors count]) {
        SEL errorSel = @selector(teamUpdateError:);
        
        if(![self.delegate respondsToSelector:errorSel])
            return;
        
        [self.delegate performSelector:errorSel 
                            withObject:[DWRequestHelper generateErrorMessageFrom:errors]];
        return;
    }
    
    DWTeam *team = [DWTeam create:data]; 
    [self.delegate performSelector:sel 
                        withObject:team];
}

//----------------------------------------------------------------------------------------------------
- (void)teamUpdateError:(NSNotification*)notification {
    
    SEL sel = @selector(teamUpdateError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end
