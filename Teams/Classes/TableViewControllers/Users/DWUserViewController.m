//
//  DWUserViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserViewController.h"
#import "DWUser.h"
#import "DWResource.h"
#import "DWGUIManager.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserViewController

@synthesize userViewDataSource  = _userViewDataSource;

//----------------------------------------------------------------------------------------------------
- (id)initWithUserID:(NSInteger)userID {
    self = [super init];
    
    if(self) {
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
        self.userViewDataSource.userID  = userID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kResourcePresenterStyleFat]
                                        forKey:[[DWResource class] className]];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(largeImageLoaded:) 
                                                     name:kNImgLargeUserLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userViewDataSource         = [[[DWUserViewDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.userViewDataSource = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userViewDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self.userViewDataSource loadUser];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamsControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)largeImageLoaded:(NSNotification*)notification {
    
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self provideResourceToVisibleCells:kResourceTypeLargeUserImage
                               resource:resource
                             resourceID:resourceID];
}


@end
