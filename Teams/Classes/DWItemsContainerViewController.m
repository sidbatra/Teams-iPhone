//
//  DWItemsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsContainerViewController.h"
#import "DWFollowedItemsViewController.h"
#import "DWCreationQueue.h"
#import "DWPostProgressView.h"
#import "DWNotificationsHelper.h"
#import "DWSession.h"

static NSString* const kTabTitle                = @"Feed";
static NSString* const kMsgUnload               = @"Unload called on items container";
static NSString* const kImgNotificationsButton  = @"button_notifications.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsContainerViewController

@synthesize followedViewController  = _followedViewController;
@synthesize smallProfilePicView     = _smallProfilePicView;
@synthesize userTitleView           = _userTitleView;


//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(tabSelectionChanged:) 
												 name:kNTabSelectionChanged
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(creationQueueUpdated:) 
												 name:kNCreationQueueUpdated
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallUserImageLoaded:) 
                                                 name:kNImgSmallUserLoaded
                                               object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(userFollowingCountUpdated:) 
                                                 name:kNUserFollowingCountUpdated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(userProfilePicUpdated:) 
                                                 name:kNUserProfilePicUpdated
                                               object:nil];    
    
	
	if (&UIApplicationDidEnterBackgroundNotification != NULL) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(applicationEnteringBackground:) 
													 name:UIApplicationDidEnterBackgroundNotification
												   object:nil];
	}	
    
    if(&UIApplicationWillEnterForegroundNotification != NULL) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(applicationEnteringForeground:) 
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav-Bar Methods

//----------------------------------------------------------------------------------------------------
- (void)setSmallUserImage:(UIImage*)smallUserImage {
    [self.smallProfilePicView setProfilePicButtonBackgroundImage:smallUserImage];
}


//----------------------------------------------------------------------------------------------------
- (void)didTapSmallUserImage:(id)sender event:(id)event {
}

//----------------------------------------------------------------------------------------------------
- (void)updateUserTitleView {
    [self.userTitleView showUserStateFor:[DWSession sharedDWSession].currentUser.firstName
                       andFollowingCount:[DWSession sharedDWSession].currentUser.followingCount];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if(!postProgressView) {
		postProgressView			= [[DWPostProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)];
		postProgressView.delegate	= self;
	}
    
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    
    [button setBackgroundImage:[UIImage imageNamed:kImgNotificationsButton] 
                      forState:UIControlStateNormal];

	[button addTarget:self action:@selector(didTapNotificationsButton:) 
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,55,44)];
    
    self.navigationItem.leftBarButtonItem   = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];

    if(!self.followedViewController)
        self.followedViewController = [[[DWFollowedItemsViewController alloc] init] autorelease];
        
    [self.view addSubview:self.followedViewController.view];
    
    
    if (!self.userTitleView)
        self.userTitleView = [[[DWUserTitleView alloc] 
                               initWithFrame:CGRectMake(kNavTitleViewX, 0,
                                                        kNavTitleViewWidth,kNavTitleViewHeight) 
                               delegate:self 
                               titleMode:kNavTitleAndSubtitleMode 
                               andButtonType:kDWButtonTypeStatic] autorelease];
    [self updateUserTitleView];
    
    if (!self.smallProfilePicView)
        self.smallProfilePicView = [[[DWSmallProfilePicView alloc] 
                                     initWithFrame:CGRectMake(260, 0, 
                                                              kNavTitleViewWidth,kNavTitleViewHeight) 
                                     andTarget:self] autorelease];
    
    [self.smallProfilePicView enableProfilePicButton];
    
    if (![DWSession sharedDWSession].currentUser.smallImage)
        [[DWSession sharedDWSession].currentUser startSmallImageDownload];
    else
        [self setSmallUserImage:[DWSession sharedDWSession].currentUser.smallImage];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {		
	NSLog(@"%@",kMsgUnload);
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.followedViewController = nil;
    self.smallProfilePicView    = nil;
    self.userTitleView          = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollToTop {
    //[followedViewController scrollToTop];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private

//----------------------------------------------------------------------------------------------------
- (void)displayNotificationsView {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications


//----------------------------------------------------------------------------------------------------
- (void)tabSelectionChanged:(NSNotification*)notification {
	
	NSDictionary *info      = [notification userInfo];
	
    NSInteger selectedIndex     = [[info objectForKey:kKeySelectedIndex] integerValue];
    //NSInteger oldSelectedIndex  = [[info objectForKey:kKeyOldSelectedIndex] integerValue];
    
    
	if(selectedIndex == kTabBarFeedIndex)  {
		
        if([DWNotificationsHelper sharedDWNotificationsHelper].unreadNotifications) {
           // if([self.navigationController.topViewController isKindOfClass:[DWNotificationsViewController class]])
           //     [(DWNotificationsViewController*)self.navigationController.topViewController hardRefresh];
           // else   
           //     [self displayNotificationsView];
        }
    }
}

//----------------------------------------------------------------------------------------------------
- (void)applicationEnteringBackground:(NSNotification*)notification {
	//if([self isSelectedTab])
	//	[self resetBadgeValue];
}

//----------------------------------------------------------------------------------------------------                                       
- (void)applicationEnteringForeground:(NSNotification*)notification {
   // if(followedViewController)
   //     [followedViewController loadNewItems];
}

//----------------------------------------------------------------------------------------------------
- (void)creationQueueUpdated:(NSNotification*)notification {
	NSDictionary *userInfo	= [notification userInfo];
	
	NSInteger totalActive	= [[userInfo objectForKey:kKeyTotalActive] integerValue];
	NSInteger totalFailed	= [[userInfo objectForKey:kKeyTotalFailed] integerValue];
	float totalProgress		= [[userInfo objectForKey:kKeyTotalProgress] floatValue];
	
	//NSLog(@"ACTIVE - %d, FAILED - %d, PROGRESS - %f",totalActive,totalFailed,totalProgress);
	
	if(totalActive || totalFailed) {
		
        if(!_isProgressBarActive) {
            _isProgressBarActive = YES;
            [self.navigationController.navigationBar addSubview:postProgressView];
            [self.userTitleView removeFromSuperview];
        }
		
		[postProgressView updateDisplayWithTotalActive:totalActive
										   totalFailed:totalFailed
										 totalProgress:totalProgress];
	}
	else {
        if(_isProgressBarActive) {
            _isProgressBarActive = NO;
            [self.navigationController.navigationBar addSubview:self.userTitleView];
            [postProgressView removeFromSuperview];
        }        
	}
}

//----------------------------------------------------------------------------------------------------
- (void)smallUserImageLoaded:(NSNotification*)notification {
	NSDictionary *info	= [notification userInfo];
	
	if([[info objectForKey:kKeyResourceID] integerValue] != [DWSession sharedDWSession].currentUser.databaseID)
		return;
    
    [self setSmallUserImage:[info objectForKey:kKeyImage]];
}

//----------------------------------------------------------------------------------------------------
- (void)userFollowingCountUpdated:(NSNotification*)notification {
    [self updateUserTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)userProfilePicUpdated:(NSNotification*)notification {    
    [self.smallProfilePicView showNormalState];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPostProgressViewDelegate
//----------------------------------------------------------------------------------------------------
- (void)deleteButtonPressed {
	[[DWCreationQueue sharedDWCreationQueue] deleteRequests];
}

//----------------------------------------------------------------------------------------------------
- (void)retryButtonPressed {
	[[DWCreationQueue sharedDWCreationQueue] retryRequests];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITouchEvents
//----------------------------------------------------------------------------------------------------
- (void)didTapNotificationsButton:(UIButton*)button {
    [self displayNotificationsView];
}

//----------------------------------------------------------------------------------------------------
- (void)didTapTitleView {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    if(_isProgressBarActive)
        [self.navigationController.navigationBar addSubview:postProgressView];
    else
        [self.navigationController.navigationBar addSubview:self.userTitleView];
    
    [self.navigationController.navigationBar addSubview:self.smallProfilePicView];
    
    [super testLaunchURL];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate
//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    [super navigationController:navigationController
         willShowViewController:viewController
                       animated:animated];
}

@end
