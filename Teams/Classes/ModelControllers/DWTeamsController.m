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
    NSLog(@"domain is %@",domain);
    NSString *localURL = [NSString stringWithFormat:kTeamURI,
                          [@"ZGVud2VuLmNvbQ=q" stringByEncodingHTMLCharacters]];
    
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
    NSLog(@"team loaded");
    SEL sel = @selector(teamLoaded:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    NSLog(@"%@",data);
    //DWUser *user        = [DWUser create:data];
    
    //[self.delegate performSelector:sel 
    //                    withObject:user];
}

//----------------------------------------------------------------------------------------------------
- (void)teamLoadError:(NSNotification*)notification {
    NSLog(@"error in loading team");
	
    SEL sel = @selector(teamLoadError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end
