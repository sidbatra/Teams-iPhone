//
//  DWContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWItemsLogicController.h"
#import "DWTeamsLogicController.h"
#import "DWUsersLogicController.h"
#import "DWTeamItemsViewController.h"
#import "DWTeamViewController.h"
#import "DWUserViewController.h"
#import "DWNotificationsViewController.h"
#import "DWInvitePeopleViewController.h"
#import "DWTabBarController.h"


@class DWTabBarController;

/**
 * Base class for containers which form the root views for
 * each of the tabs
 */
@interface DWContainerViewController : UIViewController <UINavigationControllerDelegate,DWItemsLogicControllerDelegate,
DWTeamsLogicControllerDelegate,DWUsersLogicControllerDelegate,DWTeamItemsViewControllerDelegate,
DWTeamViewControllerDelegate,DWUserViewControllerDelegate,DWNotificationsViewControllerDelegate,DWInvitePeopleViewControllerDelegate> {
    
	DWTabBarController    *_customTabBarController;
}

/**
 * Non-retained reference to the custom tab bar controller
 */
@property (nonatomic,assign) DWTabBarController *customTabBarController;

@end
