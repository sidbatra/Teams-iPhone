//
//  DWJoinTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWMembershipsController.h"

@class DWTeam;
@protocol DWJoinTeamViewControllerDelegate;

/**
 * Provides an interface for joining an existing team.
 */
@interface DWJoinTeamViewController : UIViewController <DWMembershipsControllerDelegate> {
    
    DWTeam                      *_team;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWMembershipsController     *_membershipsController;
    
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
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Controller for handling memberships requests
 */
@property (nonatomic,retain) DWMembershipsController *membershipsController;


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

