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
@class DWTeamsLogicController;
@class DWUsersLogicController;


@protocol DWJoinTeamViewControllerDelegate;

/**
 * Provides an interface for joining an existing team.
 */
@interface DWJoinTeamViewController : DWTableViewController {
    
    DWTeam                      *_team;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    
    DWJoinTeamDataSource        *_joinTeamDataSource;
    DWTeamsLogicController      *_teamsLogicController;
    DWUsersLogicController      *_usersLogicController;
        
    id<DWJoinTeamViewControllerDelegate>   _delegate;
}

/**
 * Team which the user will join
 */
@property (nonatomic,retain) DWTeam *team;

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
 * Teams logic controller encapsulates all the functionality for display and interaction
 * of a standalone or list of teams
 */
@property (nonatomic,retain) DWTeamsLogicController *teamsLogicController;

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic,retain) DWUsersLogicController *usersLogicController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWJoinTeamViewControllerDelegate> delegate;

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


