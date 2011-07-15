//
//  DWTeamsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "NSString+Helpers.h"
#import "DWTeam.h"


static NSString* const kTeamURI       = @"/teams/domain/%@.json?";


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
    }
    return self;
}

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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Teams controller released");
    
    [super dealloc];
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


@end
