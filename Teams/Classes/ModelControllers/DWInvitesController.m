//
//  DWInvitesController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWInvitesController.h"
#import "DWRequestsManager.h"
#import "DWConstants.h"
#import "DWContact.h"


static NSString* const kNewInvitesURI           = @"/invites.json?%@";

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
- (NSString*)inviteURIFrom:(NSArray*)contacts {
    NSMutableString *invites = [[[NSMutableString alloc] initWithString:kEmptyString] autorelease];
    NSInteger counter = 0;
    
    for(id contact in contacts) {
        [invites appendString:[NSString stringWithFormat:@"&invites[%d][email]=%@",counter,[(DWContact*)contact email]]];
        [invites appendString:[NSString stringWithFormat:@"&invites[%d][first_name]=%@",counter,[(DWContact*)contact firstName]]];
        [invites appendString:[NSString stringWithFormat:@"&invites[%d][last_name]=%@",counter,[(DWContact*)contact lastName]]];        
        counter++;
    }
    
    return [NSString stringWithFormat:kNewInvitesURI,invites];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createInvitesFrom:(NSArray*)array {
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:[self inviteURIFrom:array]
                                                 successNotification:kNNewInvitesCreated
                                                   errorNotification:kNNewInvitesError
                                                       requestMethod:kPost];
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
