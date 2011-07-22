//
//  DWUpdateTeamDetailsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTeamsController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavRightBarButtonView;

/*
 * Provides an interface for editing team details
 */
@interface DWUpdateTeamDetailsViewController : UIViewController<DWTeamsControllerDelegate> {
    UITextField                 *_teamNameTextField;
	UITextField                 *_teamBylineTextField;
    
    DWTeam                      *_team;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWTeamsController           *_teamsController;
}

/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *teamNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *teamBylineTextField;

/**
 * Team which the user is a part of
 */
@property (nonatomic,retain) DWTeam *team;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Controller for handling teams requests
 */
@property (nonatomic,retain) DWTeamsController *teamsController;


/**
 * Custom init with team
 */
- (id)initWithTeam:(DWTeam*)team;

@end
