//
//  DWCreateTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"
#import "DWTeamsController.h"

@class DWTeam;
@protocol DWCreateTeamViewControllerDelegate;


/**
 * Provides an interface for creating a new team.
 */
@interface DWCreateTeamViewController : UIViewController<UITextFieldDelegate,DWTeamsControllerDelegate> {
    UITextField                 *_teamNameTextField;
	UITextField                 *_teamBylineTextField;
    
    BOOL                        _hasCreatedTeam;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    DWTeamsController           *_teamsController;
    
    id<DWCreateTeamViewControllerDelegate>   _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *teamNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *teamBylineTextField;

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
 * Delegate to send updates to
 */
@property (nonatomic,assign) id<DWCreateTeamViewControllerDelegate> delegate;


@end


/**
 * Delegate protocol to receive events during 
 * the create new team lifecycle
 */
@protocol DWCreateTeamViewControllerDelegate

/*
 * Fired when a new team is created.
 */
- (void)teamCreated;

@end