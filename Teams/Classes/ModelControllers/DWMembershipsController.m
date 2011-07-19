//
//  DWMembershipsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMembershipsController.h"
#import "DWConstants.h"
#import "DWRequestsManager.h"
#import "DWRequestHelper.h"
#import "DWMembership.h"

static NSString* const kNewMembershipURI    = @"/memberships/teams/%d.json?";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMembershipsController


@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(membershipCreated:) 
													 name:kNNewMembershipCreated
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(membershipCreationError:) 
													 name:kNNewMembershipError
												   object:nil];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Memberships controller released");
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Create

//----------------------------------------------------------------------------------------------------
- (void)createMembershipForTeamID:(NSInteger)teamID {
    
    NSString *localURL = [NSString stringWithFormat:kNewMembershipURI,
                          teamID];
                          
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNNewMembershipCreated
                                                   errorNotification:kNNewMembershipError
                                                       requestMethod:kPost];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)membershipCreated:(NSNotification*)notification {
    
    SEL sel = @selector(membershipCreated:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSDictionary *info	= [notification userInfo];
    NSDictionary *data  = [info objectForKey:kKeyData];
    /*
    NSArray *errors     = [data objectForKey:kKeyErrors];

    if ([errors count] ) {
        SEL sel = @selector(membershipCreationError:);
        
        if(![self.delegate respondsToSelector:sel])
            return;
        
        [self.delegate performSelector:sel 
                            withObject:[DWRequestHelper generateErrorMessageFrom:errors]];
        return;
    }*/
    
    DWMembership *membership = [DWMembership create:data];    
    [self.delegate performSelector:sel 
                        withObject:membership];
}

//----------------------------------------------------------------------------------------------------
- (void)membershipCreationError:(NSNotification*)notification {
    
    SEL sel = @selector(membershipCreationError:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:sel 
                        withObject:[error localizedDescription]];
}

@end
