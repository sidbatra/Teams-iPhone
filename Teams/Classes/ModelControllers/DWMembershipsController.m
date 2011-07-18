//
//  DWMembershipsController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMembershipsController.h"
#import "DWConstants.h"
#import "DWRequestsManager.h"
#import "DWRequestHelper.h"

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
												 selector:@selector(membershipError:) 
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
                                                       requestMethod:kPost 
                                                        authenticate:NO];
}

@end
