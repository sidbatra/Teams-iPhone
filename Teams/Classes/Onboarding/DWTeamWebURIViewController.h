//
//  DWTeamWebURIViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DWTeamsController.h"

@class DWTeam;
@class DWNavTitleView;
@class DWNavBarRightButtonView;
@class DWSpinnerOverlayView;

@protocol DWTeamWebURIViewControllerDelegate;

/**
 * Provides an interface for editing the web-uri for the team.
 */
@interface DWTeamWebURIViewController : UIViewController<DWTeamsControllerDelegate> {
    
    UITextField                 *_teamHandleTextField;
    UIView                      *_spinnerContainerView;     
    
    DWTeam                      *_team;
    
    DWNavTitleView              *_navTitleView;
    DWNavBarRightButtonView     *_navBarRightButtonView;
    DWSpinnerOverlayView        *_spinnerOverlayView;    
    
    DWTeamsController           *_teamsController;
    
    id<DWTeamWebURIViewControllerDelegate>   __unsafe_unretained _delegate;    
}

/**
 * IBOutlets
 */
@property (nonatomic) IBOutlet UITextField *teamHandleTextField;
@property (nonatomic) IBOutlet UIView *spinnerContainerView;

/**
 * User's team
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
 * Delegate to send updates to
 */
@property (nonatomic,unsafe_unretained) id<DWTeamWebURIViewControllerDelegate> delegate;


@end


/**
 * Delegate protocol to receive events during 
 * the team web uri view lifecycle
 */
@protocol DWTeamWebURIViewControllerDelegate

/*
 * Fired when the user selects his team handle
 */
- (void)teamHandleSelected:(DWTeam*)team;

@end
