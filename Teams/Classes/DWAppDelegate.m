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
#import "DWMembership.h"
#import "JSON.h"
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
    
    /*
    NSString *json = @"{\"is_confirmed\":true,\"byline\":\"I get things done\",\"photo\":{\"large_url\":\"http://s3.amazonaws.com/denwen-teams-development/user_photos/large_1304059841_22956546334152317850_photo.jpg\",\"is_processed\":true,\"id\":1,\"small_url\":\"http://s3.amazonaws.com/denwen-teams-development/user_photos/small_1304059841_22956546334152317850_photo.jpg\"},\"id\":1,\"errors\":[],\"last_name\":\"Batra\",\"followings_count\":2,\"first_name\":\"Siddharth\",\"email\":\"sid@denwen.com\"}";
    
    DWUser *user = [DWUser create:[json JSONValue]];
    user.encryptedPassword = @"P0iDBj++DIPfsGZKzQd5sjS7nsPBiaXwUf2nBTGkhdU=";
    NSLog(@"id - %d \n first name - %@ last name - %@ \n ",user.databaseID,user.firstName,user.lastName);
    */
    
    
    /*
    NSString *json = @"{\"id\":8,\"user_id\":3,\"errors\":[],\"team_id\":3}";
    DWFollowing *following = [DWFollowing create:[json JSONValue]];
    NSLog(@"following id - %d",following.databaseID);
    [following destroy];
     */
    
    /*
    NSString *json = @"{\"large_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/large_club.jpg\",\"slice_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/slice_club.jpg\",\"filetype\":0,\"actual_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/club.jpg\",\"is_processed\":true,\"id\":4}";
    
    DWAttachment *a = [DWAttachment create:[json JSONValue]];
    NSLog(@"id - %d",a.databaseID);
    NSLog(@"slice - %@",a.sliceURL);
    NSLog(@"large - %@",a.largeURL);
    NSLog(@"actual - %@",a.actualURL);
    NSLog(@"filetype - %d",a.fileType);
    
    [a destroy];
    */
    
    /*
    NSString *json = @"{\"name\":\"Denwen\",\"byline\":\"We are the team\",\"memberships_count\":1,\"id\":1,\"errors\":[],\"attachment\":{\"large_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/large_club.jpg\",\"slice_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/slice_club.jpg\",\"filetype\":0,\"actual_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/club.jpg\",\"is_processed\":true,\"id\":4},\"timestamp\":1309474389,\"followings_count\":1}";
    
    
    
    DWTeam *team = [DWTeam create:[json JSONValue]];
    NSLog(@"id - %d",team.databaseID);
    NSLog(@"name - %@",team.name);
    NSLog(@"byline - %@",team.byline);
    NSLog(@"foll,mem,crea - %d,%d,%f",team.followingsCount,team.membersCount,team.createdAtTimestamp);
    
    NSLog(@"id - %d",team.attachment.databaseID);
    NSLog(@"slice - %@",team.attachment.sliceURL);
    NSLog(@"large - %@",team.attachment.largeURL);
    NSLog(@"actual - %@",team.attachment.actualURL);
    NSLog(@"filetype - %d",team.attachment.fileType);

    [team destroy];
     */
    /*
    NSString *json = @"{\"data\":\"this is  wonderful\",\"id\":6,\"user\":{\"byline\":\"I get things done\",\"id\":1,\"last_name\":\"Batra\",\"first_name\":\"Siddharth\"},\"team\":{\"name\":\"Denwen\",\"id\":1},\"errors\":[],\"touches_count\":0,\"attachment\":{\"large_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/large_club.jpg\",\"slice_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/slice_club.jpg\",\"filetype\":0,\"actual_url\":\"http://s3.amazonaws.com/denwen-teams-development/items/club.jpg\",\"is_processed\":true,\"id\":4},\"timestamp\":1309656129}";
    
    DWItem *item = [DWItem create:[json JSONValue]];
    NSLog(@"id - %d %d %d",item.databaseID,item.team.databaseID,item.user.databaseID);
    NSLog(@"moer - %d %d %f",item.touchesCount,item.isTouched,item.createdAtTimestamp);
    NSLog(@"name - %@,%@,%@",item.data,item.team.name,item.user.firstName);
    
    [item destroy];
     */
    
    /*
    NSString *json = @"{\"id\":1,\"user_id\":1,\"team\":{\"name\":\"Denwen\",\"id\":1},\"errors\":[],\"timestamp\":1309474389,\"team_id\":1}";
    DWMembership *mem = [DWMembership create:[json JSONValue]];
    NSLog(@"id - %d",mem.databaseID);
    NSLog(@"time - %f",mem.createdAtTimestamp);
    NSLog(@"team id ,name, byline - %d,%@,%@",mem.team.databaseID,mem.team.name,mem.team.byline);
    [mem destroy];
     */
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
	
	
	/*
	self.tabBarController.subControllers    = [NSArray arrayWithObjects:
                                               self.teamsNavController,
                                               [[[UIViewController alloc] init] autorelease],
                                               self.itemsNavController,
                                               nil];
     */
    [self.tabBarController setupSubControllers:[NSArray arrayWithObjects:
                                               [[[UIViewController alloc] init] autorelease],
                                               [[[UIViewController alloc] init] autorelease],
                                               [[[UIViewController alloc] init] autorelease],
                                               nil]];
		
	
	//((DWPlacesContainerViewController*)self.teamsNavController.topViewController).customTabBarController	= self.tabBarController;
	//((DWItemsContainerViewController*)self.itemsNavController.topViewController).customTabBarController		= self.tabBarController;
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
    
    
    //DWUser *user = [[DWMemoryPool sharedDWMemoryPool] getObjectWithID:@"1" forClass:@"DWUser"];
    //NSLog(@"AFTER SWITCH id - %d \n name - %@ \n ",user.databaseID,user.firstName);
    
    if(newSelectedIndex == kTabBarCreateIndex) {
		DWCreateViewController *createView	= [[[DWCreateViewController alloc] init] autorelease];
		[self.tabBarController presentModalViewController:createView animated:NO];
	}
}

@end
