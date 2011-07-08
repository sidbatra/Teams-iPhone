//
//  DWSession.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSession.h"
#import "DWMemoryPool.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"

static NSString* const kDiskKeyCurrentUser      = @"DWSession_currentUser";


/**
 * Private method declarations
 */
@interface DWSession()

/**
 * Read the user session from disk using NSUserDefaults
 */
- (void)read;

/**
 * Stores the current user on disk using NSUserDefaults
 */
- (void)storeCurrentUserOnDisk;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSession

@synthesize currentUser				= _currentUser;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWSession);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		[self read];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)storeCurrentUserOnDisk {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        
		NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:self.currentUser]; 
        
        [standardUserDefaults setObject:userData
                                 forKey:kDiskKeyCurrentUser];
        
        [standardUserDefaults synchronize];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)read {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		NSData *userData = [standardUserDefaults objectForKey:kDiskKeyCurrentUser];

        if(userData)
            self.currentUser = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)create:(NSDictionary*)user {
	
    self.currentUser                = [DWUser create:user];
    self.currentUser.isNewUser      = YES;
    self.currentUser.isCurrentUser  = YES;
        
    [self storeCurrentUserOnDisk];
}

//----------------------------------------------------------------------------------------------------
- (void)update {
    [self storeCurrentUserOnDisk];
}

//----------------------------------------------------------------------------------------------------
- (void)destroy {
    
    [self.currentUser destroy];
	self.currentUser = nil;
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
        [standardUserDefaults removeObjectForKey:kDiskKeyCurrentUser];
        [standardUserDefaults synchronize];
    }
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isActive {
	return self.currentUser != nil;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications



@end