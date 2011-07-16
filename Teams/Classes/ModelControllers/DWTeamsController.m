//
//  DWTeamsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWTeam.h"


static NSString* const kTeamURI             = @"/teams/domain/%@.json?";
static NSString* const kPopularTeamsURI     = @"/popular/teams.json?";
static NSString* const kRecentTeamsURI      = @"/recent/teams.json?";


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

@end
