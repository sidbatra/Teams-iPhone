//
//  DWContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//
#import "DWContainerViewController.h"

#import "DWTabBarController.h"
#import "DWUserItemsViewController.h"
#import "DWTeamItemsViewController.h"
#import "DWTeamMembersViewController.h"
#import "DWTeamFollowersViewController.h"
#import "DWItemViewController.h"
#import "DWUserTeamsViewController.h"
#import "DWUpdateUserDetailsViewController.h"

#import "DWSharingManager.h"
#import "DWItem.h"
#import "DWConstants.h"
#import "DWSession.h"
#import "NSString+Helpers.h"

static NSString*  const kDenwenURLPrefix    = @"denwen://";


/**
 * Declarations for private methods
 */
@interface DWContainerViewController()

/**
 * Parse the launch URL and perform the appropiate action
 */
//- (void)processLaunchURL:(NSString*)url;

/**
 * Test for the presence launch url in the session
 */
//- (void)testLaunchURL;

/**
 * Indicates if the container child is on the currently
 * selected tab
 */
- (BOOL)isSelectedTab;

/**
 * Displays the designated view controller when an item is selected
 */
- (void)itemSelected:(NSInteger)itemID;

/**
 * Displays the designated view controller for a team whenever one is selected
 */
- (void)teamSelected:(DWTeam*)team;

/**
 * Displays the designated view controller for a user whenever one is selected
 */
- (void)userSelected:(NSInteger)userID;

/**
 * Displays the invite people controller
 */
- (void)invitePeople;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContainerViewController

@synthesize customTabBarController  = _customTabBarController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	
    /*
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(denwenURLOpened:) 
												 name:kNDenwenURLOpened
											   object:nil];
     */
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
    return [self.customTabBarController getSelectedController] == self.navigationController;
}

//----------------------------------------------------------------------------------------------------
- (void)itemSelected:(NSInteger)itemID {
    
    DWItemViewController *itemViewController = [[[DWItemViewController alloc] initWithItemID:itemID] autorelease];
    
    [itemViewController setItemsDelegate:self];
    [itemViewController setUsersDelegate:self];
     
    [self.navigationController pushViewController:itemViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)teamSelected:(DWTeam*)team {
    
    DWTeamItemsViewController *teamItemsController = [[[DWTeamItemsViewController alloc] 
                                                       initWithTeam:team]
                                                      autorelease];
    teamItemsController.delegate = self;
    [teamItemsController setItemsDelegate:self];
    
    [self.navigationController pushViewController:teamItemsController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)userSelected:(NSInteger)userID {
    
    DWUserViewController *userViewController = [[[DWUserViewController alloc] 
                                                 initWithUserID:userID] autorelease];
    
    userViewController.delegate =  self;
    
    [self.navigationController pushViewController:userViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)invitePeople {
    NSLog(@"invite people controller");
}

//----------------------------------------------------------------------------------------------------
/*
- (void)testLaunchURL {

    NSURL *launchURL = [DWSession sharedDWSession].launchURL;
    
    if(launchURL) {
         NSString *absoluteString               = [[launchURL absoluteString] copy];
         [DWSession sharedDWSession].launchURL  = nil;
        
         [self processLaunchURL:absoluteString];
         [absoluteString release];
    }
}
*/

/*
//----------------------------------------------------------------------------------------------------
- (void)processLaunchURL:(NSString*)url {
	
    if([url hasPrefix:kDenwenURLPrefix]) {
        
        DWPlace *place          = [[[DWPlace alloc] init] autorelease];
        place.usesMemoryPool    = NO;
        place.databaseID        = [[NSDate date] timeIntervalSince1970];
        place.hashedID          = [url substringFromIndex:[kDenwenURLPrefix length]];
        
        [self displaySelectedPlace:place];
    }
}
*/
        

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
/*
- (void)denwenURLOpened:(NSNotification*)notification {
	if([self isSelectedTab]) {
		NSString *url = (NSString*)[notification object];
		[self processLaunchURL:url];
	}
}
 */


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark ItemsLogicControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)itemsLogicTeamSelected:(DWTeam*)team {
    [self teamSelected:team];
}

//----------------------------------------------------------------------------------------------------
- (void)itemsLogicUserSelected:(DWUser*)user {
    [self userSelected:user.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)itemsLogicShareSelectedForItem:(DWItem*)item {
    NSLog(@"item sharing selecred - %d",item.databaseID);
}

//----------------------------------------------------------------------------------------------------
//- (UIViewController*)requestCustomTabBarController {
//    return self.customTabBarController;
//}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TeamsLogicControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamsLogicTeamSelected:(DWTeam*)team {
    [self teamSelected:team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UsersLogicControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)usersLogicUserSelected:(DWUser *)user {
    [self userSelected:user.databaseID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TeamsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)teamDetailsSelected:(DWTeam *)team {
    
    DWTeamViewController *teamViewController    = [[[DWTeamViewController alloc] initWithTeam:team] autorelease];
    teamViewController.delegate                 = self;              
    
    [teamViewController setTeamsDelegate:self];
    
    [self.navigationController pushViewController:teamViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)showMembersOfTeam:(DWTeam*)team {
    DWTeamMembersViewController *teamMembersViewController = [[[DWTeamMembersViewController alloc]
                                                               initWithTeam:team] autorelease];
    
    [teamMembersViewController setUsersDelegate:self];
    
    [self.navigationController pushViewController:teamMembersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showFollowersOfTeam:(DWTeam*)team {
    DWTeamFollowersViewController *teamFollowersViewController = [[[DWTeamFollowersViewController alloc] 
                                                                   initWithTeam:team] autorelease];
    
    [teamFollowersViewController setUsersDelegate:self];
    
    [self.navigationController pushViewController:teamFollowersViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showInvitePeople {
    [self invitePeople];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UserViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userViewShowTeam:(DWTeam*)team {
    [self teamSelected:team];
}

//----------------------------------------------------------------------------------------------------
- (void)userViewShowTeamsWatchedBy:(DWUser*)user {
    DWUserTeamsViewController *userTeamsViewController = [[[DWUserTeamsViewController alloc] 
                                                           initWithUser:user
                                                           andIgnore:YES] autorelease];
    
    [userTeamsViewController setTeamsDelegate:self];
    
    [self.navigationController pushViewController:userTeamsViewController
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)showEditUserDetailsView:(DWUser*)user {
    
    DWUpdateUserDetailsViewController *updateUserDetailsViewController  = [[[DWUpdateUserDetailsViewController alloc]
                                                                            initWithUserToEdit:user] autorelease];
    
    updateUserDetailsViewController.displayMediaPickerController        = self.customTabBarController;

    [self.navigationController pushViewController:updateUserDetailsViewController 
                                         animated:YES];
} 


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWNotificationsViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)notificationsUserSelected:(NSInteger)userID {
    [self userSelected:userID];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsItemSelected:(NSInteger)itemID {
    [self itemSelected:itemID];
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
        [self.customTabBarController enableFullScreen];
    else
        [self.customTabBarController disableFullScreen];
}

@end
