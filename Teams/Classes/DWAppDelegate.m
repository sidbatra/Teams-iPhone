//
//  DWAppDelegate.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAppDelegate.h"
#import "DWTabBarController.h"
#import "DWItemsContainerViewController.h"
#import "DWCreateViewController.h"
#import "DWPlacesContainerViewController.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "DWSession.h"


static NSString* const kFacebookURLPrefix			= @"fb";
static NSInteger const kTabBarWidth					= 320;
static NSInteger const kTabBarHeight				= 49;
static NSString* const kImgPlacesOn					= @"tab_places_on.png";
static NSString* const kImgPlacesOff				= @"tab_places_off.png";
static NSString* const kImgCreateOn					= @"tab_create_active.png";
static NSString* const kImgCreateOff				= @"tab_create_on.png";
static NSString* const kImgFeedOn					= @"tab_feed_on.png";
static NSString* const kImgFeedOff					= @"tab_feed_off.png";


 
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppDelegate

@synthesize window				= _window;
@synthesize teamsNavController	= _placesNavController;
@synthesize itemsNavController	= _itemsNavController;

@synthesize tabBarController	= _tabBarController;


//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {    
    	    
    //[DWNotificationsHelper sharedDWNotificationsHelper].backgroundRemoteInfo = [launchOptions objectForKey:
    //                                                                                UIApplicationLaunchOptionsRemoteNotificationKey];
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(userLogsIn:) 
												 name:kNUserLogsIn
											   object:nil];
	
    
    //[DWSession sharedDWSession].launchURL = (NSURL*)[launchOptions valueForKey:@"UIApplicationLaunchOptionsURLKey"];

    return YES;
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillResignActive:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[DWMemoryPool sharedDWMemoryPool] freeMemory];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	//[[DWNotificationsHelper sharedDWNotificationsHelper] handleLiveNotificationWithUserInfo:userInfo];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    /*
	if([[url absoluteString] hasPrefix:kFacebookURLPrefix]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNFacebookURLOpened 
															object:url];	
	}
	else {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNDenwenURLOpened 
															object:[url absoluteString]];	
	}
     */
	
	return YES;
}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application {

	if(self.tabBarController == nil) 
		[self setupApplication];
			
	//[[DWNotificationsHelper sharedDWNotificationsHelper] handleBackgroundNotification];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.window					= nil;
	self.teamsNavController     = nil;
	self.itemsNavController		= nil;
	
	self.tabBarController		= nil;
		
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {	
	[[DWMemoryPool sharedDWMemoryPool] freeMemory];
}

//----------------------------------------------------------------------------------------------------
- (void)setupTabBarController {
    
    BOOL isLoggedIn     = [[DWSession sharedDWSession] isActive];
	
	NSArray *tabBarInfo	= [NSArray arrayWithObjects:
						   [NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:114]				,kKeyWidth,
							[NSNumber numberWithBool:!isLoggedIn]		,kKeyIsSelected,
							[NSNumber numberWithInt:kTabBarNormalTag]	,kKeyTag,
							kImgPlacesOn								,kKeySelectedImageName,
							kImgPlacesOff								,kKeyNormalImageName,
							nil],
						   [NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:92]					,kKeyWidth,
							[NSNumber numberWithBool:NO]				,kKeyIsSelected,
							[NSNumber numberWithInt:kTabBarSpecialTag]	,kKeyTag,
							kImgCreateOff								,kKeySelectedImageName,
							kImgCreateOn								,kKeyHighlightedImageName,
							kImgCreateOff								,kKeyNormalImageName,
							nil],
						   [NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:114]				,kKeyWidth,
							[NSNumber numberWithBool:isLoggedIn]		,kKeyIsSelected,
							[NSNumber numberWithInt:kTabBarNormalTag]	,kKeyTag,
							kImgFeedOn									,kKeySelectedImageName,
							kImgFeedOff									,kKeyNormalImageName,
							nil],
						   nil];
	
	self.tabBarController					= [[[DWTabBarController alloc] initWithDelegate:self 
																			withTabBarFrame:CGRectMake(0,411,kTabBarWidth,kTabBarHeight)
																			  andTabBarInfo:tabBarInfo] autorelease];
	
	
	
	self.tabBarController.subControllers    = [NSArray arrayWithObjects:
                                               self.teamsNavController,
                                               [[[UIViewController alloc] init] autorelease],
                                               self.itemsNavController,
                                               nil];
		
	
	((DWPlacesContainerViewController*)self.teamsNavController.topViewController).customTabBarController	= self.tabBarController;
	((DWItemsContainerViewController*)self.itemsNavController.topViewController).customTabBarController		= self.tabBarController;
}

//----------------------------------------------------------------------------------------------------
- (void)setupApplication {	
	[self setupTabBarController];	
	
	[self.window addSubview:self.tabBarController.view];
	[self.window makeKeyAndVisible];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)userLogsIn:(NSNotification*)notification {
    
	//if(![[UIApplication sharedApplication] enabledRemoteNotificationTypes])
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge | 
                                                                            UIRemoteNotificationTypeSound | 
                                                                            UIRemoteNotificationTypeAlert];
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Push Notification Permission Responses


//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	[[DWRequestsManager sharedDWRequestsManager] updateDeviceIDForCurrentUser:[NSString stringWithFormat:@"%@",deviceToken]];
}

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
							 to:(NSInteger)newSelectedIndex {
		
	if(newSelectedIndex == kTabBarCreateIndex) {
		DWCreateViewController *createView	= [[[DWCreateViewController alloc] init] autorelease];
		[self.tabBarController presentModalViewController:createView animated:NO];
	}
}

@end
