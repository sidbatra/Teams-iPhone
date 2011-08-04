//
//  DWUserItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserItemsViewController.h"
#import "DWUserItemsDataSource.h"  
#import "DWItem.h"
#import "DWUser.h"
#import "NSObject+Helpers.h"
#import "DWGUIManager.h"
#import "DWUsersHelper.h"
#import "DWNavTitleView.h"
#import "DWSmallProfilePicView.h"


/**
 * Private method and property declarations
 */
@interface DWUserItemsViewController()

/**
 * Update the display of the title view
 */
- (void)updateTitleViewWithUser:(DWUser*)user;

/**
 * Set the image for the small profile pic view
 */
- (void)setProfilePicture:(UIImage*)image;

/**
 * Add the title view to the navigation bar
 */
- (void)loadNavTitleView;

/**
 * Load the profile picture onto the nav bar
 */ 
- (void)loadSmallProfilePicView;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserItemsViewController

@synthesize userItemsDataSource     = _userItemsDataSource;
@synthesize navTitleView            = _navTitleView;
@synthesize smallProfilePicView     = _smallProfilePicView;

//----------------------------------------------------------------------------------------------------
- (id)initWithUserID:(NSInteger)userID {
    
    self = [super init];
    
    if(self) {
        self.userItemsDataSource        = [[[DWUserItemsDataSource alloc] init] autorelease];
        self.userItemsDataSource.userID = userID;
        
        [self.modelPresentationStyle setObject:[NSNumber numberWithInt:kItemPresenterStyleUserItems]
                                                                forKey:[[DWItem class] className]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(smallUserImageLoaded:) 
                                                     name:kNImgSmallUserLoaded
                                                   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.userItemsDataSource  = [[[DWUserItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.userItemsDataSource    = nil;
    self.navTitleView           = nil;
    self.smallProfilePicView    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.userItemsDataSource;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
        
    self.navigationItem.leftBarButtonItem = [DWGUIManager navBarBackButtonForNavController:self.navigationController];
    
    [self loadNavTitleView];
    [self loadSmallProfilePicView];
       
    [self.userItemsDataSource loadItems];
    [self.userItemsDataSource loadUser];
}

//----------------------------------------------------------------------------------------------------
- (void)updateTitleViewWithUser:(DWUser*)user {
    [self.navTitleView displayTitle:[DWUsersHelper displayName:user] 
                        andSubTitle:user.byline];
}

//----------------------------------------------------------------------------------------------------
- (void)setProfilePicture:(UIImage*)image {
    [self.smallProfilePicView setProfilePicButtonBackgroundImage:image];
}

//----------------------------------------------------------------------------------------------------
- (void)loadNavTitleView {
    
    if(!self.navTitleView) {
        self.navTitleView = [[[DWNavTitleView alloc] initWithFrame:CGRectMake(kNavTitleViewX,
                                                                             kNavTitleViewY,
                                                                             kNavTitleViewWidth,
                                                                             kNavTitleViewHeight) 
                                                      andDelegate:nil] autorelease];
    }
    
    DWUser *user = [DWUser fetch:self.userItemsDataSource.userID];
    [self updateTitleViewWithUser:user];
}

//----------------------------------------------------------------------------------------------------
- (void)loadSmallProfilePicView {
    
    if(!self.smallProfilePicView) {
        self.smallProfilePicView = [[[DWSmallProfilePicView alloc] 
                                     initWithFrame:CGRectMake(kNavRightButtonX,
                                                              kNavRightButtonY, 
                                                              kNavRightButtonWidth,
                                                              kNavRightButtonHeight)] autorelease];
    }
    
    DWUser *user = [DWUser fetch:self.userItemsDataSource.userID];
    
    if(user.smallImage)
        [self setProfilePicture:user.smallImage];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWUserItemsDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)userLoaded:(DWUser*)user {
    [self updateTitleViewWithUser:user];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)willShowOnNav {
    [self.navigationController.navigationBar addSubview:self.navTitleView];
    [self.navigationController.navigationBar addSubview:self.smallProfilePicView];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)smallUserImageLoaded:(NSNotification*)notification {
    
	NSDictionary *info	= [notification userInfo];
    DWUser *user        = [DWUser fetch:self.userItemsDataSource.userID];
    
    
	if([[info objectForKey:kKeyResourceID] integerValue] != user.databaseID)
		return;
    
    [self setProfilePicture:[info objectForKey:kKeyImage]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark FullScreenMode
//----------------------------------------------------------------------------------------------------
- (void)requiresFullScreenMode {
    
}

@end
