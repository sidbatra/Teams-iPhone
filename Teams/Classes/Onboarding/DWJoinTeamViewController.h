//
//  DWJoinTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTableViewController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWJoinTeamDataSource;
@class DWUsersLogicController;

@protocol DWUsersLogicControllerDelegate;
@protocol DWJoinTeamViewControllerDelegate;

/**
 * Provides an interface for joining an existing team.
 */
@interface DWJoinTeamViewController : DWTableViewController {
    
    DWTeam                      *_team;
    
    UIImageView                 *_topShadowView;    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    
    DWJoinTeamDataSource        *_joinTeamDataSource;
    DWUsersLogicController      *_usersLogicController;
        
    id<DWJoinTeamViewControllerDelegate>   _delegate;
}

/**
 * Team which the user will join
 */
@property (nonatomic,retain) DWTeam *team;

/**
 * Image view with a shadow just below the navigation bar
 */
@property (nonatomic,retain) UIImageView *topShadowView;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWJoinTeamDataSource *joinTeamDataSource;

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic,retain) DWUsersLogicController *usersLogicController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWJoinTeamViewControllerDelegate> delegate;


/**
 * Set a users logic controller delegate
 */
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate;

@end


/**
 * Delegate protocol to receive events during 
 * the join existing team lifecycle
 */
@protocol DWJoinTeamViewControllerDelegate

/*
 * Fired when the user joins a team.
 */
- (void)teamJoined:(DWTeam*)team;

@end


