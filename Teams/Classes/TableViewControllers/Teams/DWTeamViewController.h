//
//  DWTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWTeamViewDataSource;
@class DWTeamsLogicController;
@protocol DWTeamsLogicControllerDelegate;
@protocol DWTeamViewControllerDelegate;

/**
 * Table view for displaying details about a team
 */
@interface DWTeamViewController : DWTableViewController {
    BOOL                        _isUsersTeam;
    
    DWTeamViewDataSource        *_teamViewDataSource;
    DWTeamsLogicController      *_teamsLogicController;
    
    DWNavTitleView              *_navTitleView;
        
    id<DWTeamViewControllerDelegate>    _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWTeamViewDataSource *teamViewDataSource;

/**
 * Encapsulates functionality to display one or more teams
 */
@property (nonatomic,retain) DWTeamsLogicController *teamsLogicController;

/**
 * Custom nav bar title
 */ 
@property (nonatomic,retain) DWNavTitleView *navTitleView;

/**
 * Delegate based on the DWTeamViewControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWTeamViewControllerDelegate> delegate;



/**
 * Init with the team whose details are being displayed
 */
- (id)initWithTeam:(DWTeam*)team;

/**
 * Set a delegate that responds to the DWTeamsLogicControllerDelegate protocol
 */
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate;

@end


/**
 * Protocol for delegates of DWTeamViewController
 */
@protocol DWTeamViewControllerDelegate

/**
 * Fired when the invite people view is to be displayed
 */
- (void)showInvitePeopleFor:(DWTeam*)team;;

/**
 * Fired when the share team view is to be displayed
 */
- (void)shareTeam:(DWTeam*)team;;

@end
