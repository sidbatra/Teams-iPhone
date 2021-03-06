//
//  DWAppDelegate.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWAppDelegate.h"
#import "DWContainerViewController.h"
#import "DWCreateViewController.h"
#import "DWPushNotificationsManager.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"
#import "DWSession.h"


static NSString* const kFacebookURLPrefix			= @"fb";
static NSInteger const kTabBarWidth					= 320;
static NSInteger const kTabBarHeight				= 49;
static NSString* const kImgPlacesOn					= @"tab_teams_on.png";
static NSString* const kImgPlacesOff				= @"tab_teams_off.png";
static NSString* const kImgCreateOn					= @"tab_create_off.png";
static NSString* const kImgCreateOff				= @"tab_create_off.png";
static NSString* const kImgFeedOn					= @"tab_feed_on.png";
static NSString* const kImgFeedOff					= @"tab_feed_off.png";


 
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWAppDelegate

@synthesize window                      = _window;
@synthesize teamsNavController          = _placesNavController;
@synthesize itemsNavController          = _itemsNavController;
@synthesize onboardingNavController     = _onboardingNavController;

@synthesize tabBarController            = _tabBarController;


//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {    
    	    
    [DWPushNotificationsManager sharedDWPushNotificationsManager].backgroundNotificationInfo = [launchOptions objectForKey:
                                                                                    UIApplicationLaunchOptionsRemoteNotificationKey];
    
    [DWAnalyticsManager sharedDWAnalyticsManager];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kNEnteringLowMemoryState
                                                        object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillEnterForeground:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[[DWPushNotificationsManager sharedDWPushNotificationsManager] handleLiveNotificationWithInfo:userInfo];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
	if([[url absoluteString] hasPrefix:kFacebookURLPrefix]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:kNFacebookURLOpened 
															object:url];	
	}
	else {
		//[[NSNotificationCenter defaultCenter] postNotificationName:kNDenwenURLOpened 
		//													object:[url absoluteString]];	
	}
     
	
	return YES;
}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidBecomeActive:(UIApplication *)application {

	if(self.tabBarController == nil) 
		[self setupApplication];
    
	[[DWPushNotificationsManager sharedDWPushNotificationsManager] handleBackgroundNotification];    
}

//----------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate:(UIApplication *)application {
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.window                     = nil;
	self.teamsNavController         = nil;
	self.itemsNavController         = nil;
    self.onboardingNavController    = nil; 
	
	self.tabBarController           = nil;
		
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {	
    [[NSNotificationCenter defaultCenter] postNotificationName:kNEnteringLowMemoryState
                                                        object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)setupTabBarController {
    
    //BOOL isLoggedIn     = [[DWSession sharedDWSession] isExhaustive];
	
	NSArray *tabBarInfo	= [NSArray arrayWithObjects:
						   [NSDictionary dictionaryWithObjectsAndKeys:
							[NSNumber numberWithInt:114]				,kKeyWidth,
							[NSNumber numberWithBool:NO]		,kKeyIsSelected,
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
							[NSNumber numberWithBool:YES]		,kKeyIsSelected,
							[NSNumber numberWithInt:kTabBarNormalTag]	,kKeyTag,
							kImgFeedOn									,kKeySelectedImageName,
							kImgFeedOff									,kKeyNormalImageName,
							nil],
						   nil];
	
	self.tabBarController	= [[[DWTabBarController alloc] initWithTabBarFrame:CGRectMake(0,411,kTabBarWidth,kTabBarHeight)
                                                                 andTabBarInfo:tabBarInfo] autorelease];
    
    self.tabBarController.delegate = self;
	
    [self.tabBarController setupSubControllers:[NSArray arrayWithObjects:
                                               self.teamsNavController,
                                               [[[UIViewController alloc] init] autorelease],
                                               self.itemsNavController,
                                               nil]];
    
	
	((DWContainerViewController*)self.teamsNavController.topViewController).customTabBarController	= self.tabBarController;
	((DWContainerViewController*)self.itemsNavController.topViewController).customTabBarController	= self.tabBarController;
}

//----------------------------------------------------------------------------------------------------
- (void)setupApplication {	
	[self setupTabBarController];	
	
	[self.window addSubview:self.tabBarController.view];
	[self.window makeKeyAndVisible];
    
    
    if(![[DWSession sharedDWSession] isExhaustive])
        [self.tabBarController presentModalViewController:self.onboardingNavController
                                                 animated:NO];
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
    self.onboardingNavController = nil;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Push Notification Permission Responses

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [[DWPushNotificationsManager sharedDWPushNotificationsManager] setDeviceToken:deviceToken
                                                                        forUserID:[DWSession sharedDWSession].currentUser.databaseID];
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:[DWPushNotificationsManager sharedDWPushNotificationsManager]
                                                             withActionName:@"push_notifications_registered"];   
}

//----------------------------------------------------------------------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:[DWPushNotificationsManager sharedDWPushNotificationsManager]
                                                             withActionName:@"push_notifications_rejected"];   
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabModifiedFrom:(NSInteger)oldSelectedIndex 
							 to:(NSInteger)newSelectedIndex {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.tabBarController
                                                             withActionName:@"tab_selection_changed"
                                                               andExtraInfo:[NSString stringWithFormat:@"old=%d&new=%d",
                                                                             oldSelectedIndex,
                                                                             newSelectedIndex]];   
    
    
    if(newSelectedIndex == kTabBarCreateIndex) {
		DWCreateViewController *createView	= [[[DWCreateViewController alloc] init] autorelease];
		[self.tabBarController presentModalViewController:createView 
                                                 animated:NO];
	}
}

@end
