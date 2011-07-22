//
//  DWCreateTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTeamsController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavRightBarButtonView;
@class DWSpinnerOverlayView;

@protocol DWCreateTeamViewControllerDelegate;


/**
 * Provides an interface for creating a new team.
 */
@interface DWCreateTeamViewController : UIViewController<UITextFieldDelegate,DWTeamsControllerDelegate> {
    
    UITextField                 *_teamNameTextField;
	UITextField                 *_teamBylineTextField;
    UILabel                     *_messageLabel;
    UIView                      *_spinnerContainerView; 
    
	NSString                    *_domain;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWTeamsController           *_teamsController;
    
    id<DWCreateTeamViewControllerDelegate>   _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *teamNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *teamBylineTextField;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * Team domain from the user email
 */
@property (nonatomic,copy) NSString *domain;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic,retain) DWSpinnerOverlayView *spinnerOverlayView; 

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
- (void)teamCreated:(DWTeam*)team;

@end