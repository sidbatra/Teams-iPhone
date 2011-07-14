//
//  DWContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//
#import "DWContainerViewController.h"
#import "DWTabBarController.h"
#import "DWWebViewController.h"
#import "DWSharingManager.h"
#import "DWConstants.h"
#import "DWSession.h"
#import "NSString+Helpers.h"

static NSString*  const kDenwenURLPrefix    = @"denwen://";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContainerViewController

@synthesize customTabBarController  = _customTabBarController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(denwenURLOpened:) 
												 name:kNDenwenURLOpened
											   object:nil];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    self.navigationController.delegate = self;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
	if(![self isSelectedTab])
		[super didReceiveMemoryWarning];   
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isSelectedTab {
    return [(DWTabBarController*)self.customTabBarController getSelectedController] == self.navigationController;
}


//----------------------------------------------------------------------------------------------------
- (void)testLaunchURL {
    /*
    NSURL *launchURL = [DWSession sharedDWSession].launchURL;
    
    if(launchURL) {
         NSString *absoluteString               = [[launchURL absoluteString] copy];
         [DWSession sharedDWSession].launchURL  = nil;
        
         [self processLaunchURL:absoluteString];
         [absoluteString release];
    }
     */
}

//----------------------------------------------------------------------------------------------------
- (void)processLaunchURL:(NSString*)url {
	
    if([url hasPrefix:kDenwenURLPrefix]) {
        /*
        DWPlace *place          = [[[DWPlace alloc] init] autorelease];
        place.usesMemoryPool    = NO;
        place.databaseID        = [[NSDate date] timeIntervalSince1970];
        place.hashedID          = [url substringFromIndex:[kDenwenURLPrefix length]];
        
        [self displaySelectedPlace:place];*/
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)denwenURLOpened:(NSNotification*)notification {
	if([self isSelectedTab]) {
		NSString *url = (NSString*)[notification object];
		[self processLaunchURL:url];
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ItemFeedViewControllerDelegate

//----------------------------------------------------------------------------------------------------
/*
- (void)placeSelected:(DWPlace*)place {
	[self displaySelectedPlace:place];
}
 */

//----------------------------------------------------------------------------------------------------
- (void)userSelected:(DWUser*)user {
	//DWUserViewController *userView = [[DWUserViewController alloc] initWithUser:user
	//																  andDelegate:self];
	//[self.navigationController pushViewController:userView 
	//									 animated:YES];
	//[userView release];
}

//----------------------------------------------------------------------------------------------------
- (void)shareSelected:(DWItem *)item {
}

//----------------------------------------------------------------------------------------------------
- (UIViewController*)requestCustomTabBarController {
    return self.customTabBarController;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIControlEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapBackButton:(id)sender event:(id)event {
	[self.navigationController popViewControllerAnimated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
	for (UIView *view in [self.navigationController.navigationBar subviews]) 
		if ([view respondsToSelector:@selector(shouldBeRemovedFromNav)]) 
            [view removeFromSuperview];
    
    
    if ([viewController respondsToSelector:@selector(willShowOnNav)])
        [viewController performSelector:@selector(willShowOnNav)];
    
    if ([viewController respondsToSelector:@selector(requiresFullScreenMode)])
        [(DWTabBarController*)self.customTabBarController enableFullScreen];
    else
        [(DWTabBarController*)self.customTabBarController disableFullScreen];
}

@end
