//
//  DWInvitesController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInvitesController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "DWContact.h"


static NSString* const kNewInvitesURI           = @"/invites.json?";
static NSString* const kTeamIDParamName         = @"team_id";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWInvitesController

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(invitesCreated:) 
                                                     name:kNNewInvitesCreated
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(invitesCreationError:) 
                                                     name:kNNewInvitesError
                                                   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Invites controller released");    
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (NSMutableDictionary*)inviteParamFrom:(NSArray*)contacts {
    
    NSMutableDictionary *dict   = [NSMutableDictionary dictionary];
    NSInteger counter           = 0;
    
    for(id contact in contacts) {
        [dict setObject:[(DWContact*)contact email]     forKey:[NSString stringWithFormat:@"invites[%d][email]",counter]];
        [dict setObject:[(DWContact*)contact firstName] forKey:[NSString stringWithFormat:@"invites[%d][first_name]",counter]];
        [dict setObject:[(DWContact*)contact lastName]  forKey:[NSString stringWithFormat:@"invites[%d][last_name]",counter]];
        
        counter++;
    }
    
    return dict;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createInvitesFrom:(NSArray*)contacts 
                andTeamID:(NSInteger)teamID {
    
    NSMutableDictionary *params = [self inviteParamFrom:contacts];
    
    [params setObject:[NSNumber numberWithInteger:teamID]
               forKey:kTeamIDParamName];
    
    [[DWRequestsManager sharedDWRequestsManager] createPostBodyBasedDenwenRequest:kNewInvitesURI
                                                                       withParams:params
                                                              successNotification:kNNewInvitesCreated
                                                                errorNotification:kNNewInvitesError];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)invitesCreated:(NSNotification*)notification {
    SEL sel = @selector(invitesCreated);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    NSLog(@"invite creation data \n %@",data);
    
    [self.delegate performSelector:sel];
}

//----------------------------------------------------------------------------------------------------
- (void)invitesCreationError:(NSNotification*)notification {
	
    SEL sel = @selector(invitesCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}


@end
