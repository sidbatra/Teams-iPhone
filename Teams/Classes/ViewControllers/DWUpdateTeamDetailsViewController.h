//
//  DWUpdateTeamDetailsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWTeamsController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

/*
 * Provides an interface for editing team details
 */
@interface DWUpdateTeamDetailsViewController : UIViewController<UITextFieldDelegate,DWTeamsControllerDelegate> {
    UITextField                 *_teamNameTextField;
	UITextField                 *_teamBylineTextField;
    UILabel                     *_messageLabel;    
    UIView                      *_spinnerContainerView;     
    
    DWTeam                      *_team;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;        
    
    DWTeamsController           *_teamsController;
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UITextField *teamNameTextField;
@property (nonatomic) IBOutlet UITextField *teamBylineTextField;
@property (nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;


/**
 * Team which the user is a part of
 */
@property (nonatomic) DWTeam *team;

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
 * Custom init with team
 */
- (id)initWithTeam:(DWTeam*)team;

@end
