//
//  DWContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//
#import "DWContainerViewController.h"

#import "DWUserItemsViewController.h"
#import "DWTeamItemsViewController.h"
#import "DWTeamMembersViewController.h"
#import "DWTeamFollowersViewController.h"
#import "DWItemViewController.h"
#import "DWUserTeamsViewController.h"
#import "DWUpdateUserDetailsViewController.h"
#import "DWCreateViewController.h"
#import "DWShareTeamViewController.h"

#import "DWItem.h"
#import "DWConstants.h"
#import "DWSession.h"
#import "NSString+Helpers.h"

static NSString* const kDenwenURLPrefix             = @"denwen://";
static NSString* const kMsgInviteMessageText        = @"Invite people to join this Team.";


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
- (void)teamSelected:(NSInteger)teamID;

/**
 * Displays the designated view controller for a user whenever one is selected
 */
- (void)userSelected:(NSInteger)userID;

/**
 * Display the create item view
 */
- (void)createItemSelected:(NSString*)text;

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
- (void)teamSelected:(NSInteger)teamID {
    
    DWTeamItemsViewController *teamItemsController = [[[DWTeamItemsViewController alloc] 
                                                       initWithTeamID:teamID]
                                                      autorelease];
    teamItemsController.shellViewController = (UIViewController*)self.customTabBarController;
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
- (void)createItemSelected:(NSString *)text {
    
    DWCreateViewController *createViewController = [[[DWCreateViewController alloc] 
                                                     init] autorelease];
    
    createViewController.placeholder = text;
    
    [self.navigationController pushViewController:createViewController
                                         animated:YES];
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
    [self teamSelected:team.databaseID];
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
    [self teamSelected:team.databaseID];
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

    [teamViewController setUsersDelegate:self];
    
    [self.navigationController pushViewController:teamViewController
                                         animated:YES];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark TeamViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)showInvitePeopleFor:(DWTeam*)team {
    
    self.navigationController.navigationBar.clipsToBounds       = NO;
    
    DWInvitePeopleViewController *invitePeopleViewController    = [[[DWInvitePeopleViewController alloc] init] autorelease];
    invitePeopleViewController.delegate                         = self;
    
    invitePeopleViewController.showBackButton                   = YES;
        
    invitePeopleViewController.navBarTitle                      = kAddPeopleText;
    invitePeopleViewController.navBarSubTitle                   = [NSString stringWithFormat:kAddPeopleSubText,team.name];
    
    invitePeopleViewController.messageLabelText                 = kMsgInviteMessageText;
    invitePeopleViewController.teamID                           = team.databaseID;
    
    [self.navigationController pushViewController:invitePeopleViewController 
                                         animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)shareTeam:(DWTeam*)team {
    self.navigationController.navigationBar.clipsToBounds       = NO;
    
    DWShareTeamViewController *shareTeamViewController          = [[[DWShareTeamViewController alloc] init] autorelease];
    shareTeamViewController.team                                = team;
    
    [self.navigationController pushViewController:shareTeamViewController 
                                         animated:YES];    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UserViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)userViewShowTeam:(DWTeam*)team {
    [self teamSelected:team.databaseID];
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
- (void)notificationsTeamSelected:(NSInteger)teamID {
    [self teamSelected:teamID];
}

//----------------------------------------------------------------------------------------------------
- (void)notificationsCreateSelectedWithText:(NSString *)text {
    [self createItemSelected:text];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWInvitePeopleViewControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)peopleInvitedToATeam {
    [self.navigationController popViewControllerAnimated:YES];    
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
    
    
    if ([viewController respondsToSelector:@selector(hideTopShadowOnTabBar)])
        [self.customTabBarController hideTopShadowView];
    else
        [self.customTabBarController showTopShadowView];
        /*
        [self.customTabBarController performSelector:@selector(showTopShadowView) 
                                          withObject:nil
                                          afterDelay:0.5];
         */
}

@end
