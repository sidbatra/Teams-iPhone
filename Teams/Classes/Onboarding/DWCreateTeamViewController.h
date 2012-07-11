//
//  DWCreateTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTeamsController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
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
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWTeamsController           *_teamsController;
    
    id<DWCreateTeamViewControllerDelegate>   __unsafe_unretained _delegate;
}


/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UITextField *teamNameTextField;
@property (nonatomic) IBOutlet UITextField *teamBylineTextField;
@property (nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;

/**
 * Team domain from the user email
 */
@property (nonatomic,copy) NSString *domain;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic) DWNavTitleView *navTitleView;
@property (nonatomic) DWNavBarRightButtonView *navBarRightButtonView;

/**
 * Custom overlay spinner view
 */
@property (nonatomic) DWSpinnerOverlayView *spinnerOverlayView; 

/**
 * Controller for handling teams requests
 */
@property (nonatomic) DWTeamsController *teamsController;

/**
 * Delegate to send updates to
 */
@property (nonatomic,unsafe_unretained) id<DWCreateTeamViewControllerDelegate> delegate;


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