//
//  DWItemsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsContainerViewController.h"
#import "DWCreationQueue.h"
#import "DWPostProgressView.h"
#import "DWNotificationsHelper.h"
#import "DWSession.h"

static NSString* const kTabTitle                = @"Feed";
static NSString* const kMsgUnload               = @"Unload called on items container";
static NSString* const kImgNotificationsButton  = @"button_notifications.png";


/**
 * Private method and property declarations
 */
@interface DWItemsContainerViewController()

/**
 * Apply a profile picture on the top right button
 */
- (void)setProfilePicture:(UIImage*)image;

/**
 * View creation methods
 */
- (void)loadNotificationsButton;
- (void)loadProgressView;
- (void)loadFollowedView;
- (void)loadProfilePicView;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsContainerViewController

@synthesize followedViewController  = _followedViewController;
@synthesize postProgressView        = _postProgressView;
@synthesize smallProfilePicView     = _smallProfilePicView;

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
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollToTop {
    //[followedViewController scrollToTop];
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
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {		
	NSLog(@"%@",kMsgUnload);
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark View Lifecycle

//----------------------------------------------------------------------------------------------------
- (void)loadNotificationsButton {
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:kImgNotificationsButton] 
                      forState:UIControlStateNormal];
    
	[button addTarget:self 
               action:@selector(didTapNotificationsButton:) 
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,55,44)];
    
    
    self.navigationItem.leftBarButtonItem   = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
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
        self.followedViewController.delegate    = self;
    }
    
    [self.view addSubview:self.followedViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadProfilePicView {
    
    if (!self.smallProfilePicView) {
        self.smallProfilePicView = [[[DWSmallProfilePicView alloc] 
                                     initWithFrame:CGRectMake(260, 0, 
                                                              kNavTitleViewWidth,kNavTitleViewHeight)] autorelease];
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
            //[self.userTitleView removeFromSuperview];
        }
		
		[self.postProgressView updateDisplayWithTotalActive:totalActive
                                                totalFailed:totalFailed
                                              totalProgress:totalProgress];
	}
	else if(_isProgressBarActive) {
            _isProgressBarActive = NO;
            //[self.navigationController.navigationBar addSubview:self.userTitleView];
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
    NSLog(@"profile picture touched");
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
    NSLog(@"notification button touched");
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
        //Add user title view
    
    [self.navigationController.navigationBar addSubview:self.smallProfilePicView];    
}

@end