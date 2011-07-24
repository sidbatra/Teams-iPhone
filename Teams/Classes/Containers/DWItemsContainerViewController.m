//
//  DWItemsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsContainerViewController.h"
#import "DWFollowedItemsViewController.h"
#import "DWNotificationsViewController.h"
#import "DWUserViewController.h"

#import "DWNavTitleView.h"
#import "DWUsersHelper.h"
#import "DWCreationQueue.h"
#import "DWNotificationsHelper.h"
#import "DWGUIManager.h"
#import "DWSession.h"

static NSString* const kMsgUnload               = @"Unload called on items container";

/**
 * Private method and property declarations
 */
@interface DWItemsContainerViewController()

/**
 * Apply a profile picture on the top right button
 */
- (void)setProfilePicture:(UIImage*)image;

/**
 * Update the display of the nav title view
 */
- (void)updateNavTitleView;

/**
 * View creation methods
 */
- (void)loadNotificationsButton;
- (void)loadProgressView;
- (void)loadFollowedView;
- (void)loadProfilePicView;
- (void)loadNavTitleView;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsContainerViewController

@synthesize followedViewController  = _followedViewController;
@synthesize postProgressView        = _postProgressView;
@synthesize smallProfilePicView     = _smallProfilePicView;
@synthesize navTitleView            = _navTitleView;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(creationQueueUpdated:) 
												 name:kNCreationQueueUpdated
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(smallUserImageLoaded:) 
                                                 name:kNImgSmallUserLoaded
                                               object:nil];  
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.followedViewController     = nil;
    self.postProgressView           = nil;
    self.smallProfilePicView        = nil;
    self.navTitleView               = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollToTop {
    [self.followedViewController scrollToTop];
}

//----------------------------------------------------------------------------------------------------
- (void)setProfilePicture:(UIImage*)image {
    [self.smallProfilePicView setProfilePicButtonBackgroundImage:image];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];    

    [self loadNotificationsButton];
    [self loadProgressView];
    [self loadFollowedView];
    [self loadProfilePicView];
    [self loadNavTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {		
    [super viewDidUnload];
    
	NSLog(@"%@",kMsgUnload);
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)loadNotificationsButton {
    
    UIBarButtonItem *button = [DWGUIManager navBarDetailsButtonWithTarget:self
                                                              andSelector:@selector(didTapNotificationsButton:)];
    
    self.navigationItem.leftBarButtonItem   = button;
}

//----------------------------------------------------------------------------------------------------
- (void)loadProgressView {
    
    if(!self.postProgressView) {    
        self.postProgressView			= [[[DWPostProgressView alloc] initWithFrame:CGRectMake(60,0,200,44)] autorelease];
        self.postProgressView.delegate	= self;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)loadFollowedView {
    
    if(!self.followedViewController) {
        self.followedViewController             = [[[DWFollowedItemsViewController alloc] init] autorelease];
        [self.followedViewController setItemsDelegate:self];
    }
    
    [self.view addSubview:self.followedViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadProfilePicView {
    
    if (!self.smallProfilePicView) {
        self.smallProfilePicView = [[[DWSmallProfilePicView alloc] 
                                     initWithFrame:CGRectMake(kNavRightButtonX,
                                                              kNavRightButtonY, 
                                                              kNavRightButtonWidth,
                                                              kNavRightButtonHeight)] autorelease];
        self.smallProfilePicView.delegate = self;
    }
    
    [self.smallProfilePicView enableProfilePicButton];
    
    
    UIImage *userImage = [DWSession sharedDWSession].currentUser.smallImage;
    
    if (userImage)
        [self setProfilePicture:userImage];
    else
        [[DWSession sharedDWSession].currentUser startSmallImageDownload];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:nil];
    }

    [self updateNavTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)updateNavTitleView {
    [self.navTitleView displayPassiveButtonWithTitle:[DWUsersHelper displayName:[DWSession sharedDWSession].currentUser]
                                         andSubTitle:[DWSession sharedDWSession].currentUser.byline
                                    withEnabledState:NO];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)creationQueueUpdated:(NSNotification*)notification {
	NSDictionary *userInfo	= [notification userInfo];
	
	NSInteger totalActive	= [[userInfo objectForKey:kKeyTotalActive] integerValue];
	NSInteger totalFailed	= [[userInfo objectForKey:kKeyTotalFailed] integerValue];
	float totalProgress		= [[userInfo objectForKey:kKeyTotalProgress] floatValue];
	
	
	if(totalActive || totalFailed) {
		
        if(!_isProgressBarActive) {
            _isProgressBarActive = YES;
            [self.navigationController.navigationBar addSubview:self.postProgressView];
            [self.navTitleView removeFromSuperview];
        }
		
		[self.postProgressView updateDisplayWithTotalActive:totalActive
                                                totalFailed:totalFailed
                                              totalProgress:totalProgress];
	}
	else if(_isProgressBarActive) {
            _isProgressBarActive = NO;
            [self.navigationController.navigationBar addSubview:self.navTitleView];
            [self.postProgressView removeFromSuperview];
    }        
}

//----------------------------------------------------------------------------------------------------
- (void)smallUserImageLoaded:(NSNotification*)notification {
	NSDictionary *info	= [notification userInfo];
	
	if([[info objectForKey:kKeyResourceID] integerValue] != [DWSession sharedDWSession].currentUser.databaseID)
		return;
    
    [self setProfilePicture:[info objectForKey:kKeyImage]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSmallProfilePicViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)profilePictureTouched {
    
    DWUserViewController *userViewController = [[[DWUserViewController alloc] 
                                                 initWithUserID:[DWSession sharedDWSession].currentUser.databaseID]
                                                autorelease];
    
    userViewController.delegate =  self;
    
    [self.navigationController pushViewController:userViewController
                                         animated:YES];
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
 
    
    DWNotificationsViewController *notificationsViewController = [[[DWNotificationsViewController alloc] 
                                                                   init] autorelease];
    
    [self.navigationController pushViewController:notificationsViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    
    if(_isProgressBarActive)
        [self.navigationController.navigationBar addSubview:self.postProgressView];
    else
        [self.navigationController.navigationBar addSubview:self.navTitleView];

    
    [self.navigationController.navigationBar addSubview:self.smallProfilePicView];    
}

@end
