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
    
    id<DWTeamWebURIViewControllerDelegate>   _delegate;    
}

/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *teamHandleTextField;
@property (nonatomic, retain) IBOutlet UIView *spinnerContainerView;

/**
 * User's team
 */
@property (nonatomic,retain) DWTeam *team;

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavBarRightButtonView *navBarRightButtonView;

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
@property (nonatomic,assign) id<DWTeamWebURIViewControllerDelegate> delegate;


@end


/**
 * Delegate protocol to receive events during 
 * the team web uri view lifecycle
 */
@protocol DWTeamWebURIViewControllerDelegate

/*
 * Fired when the user selects his team handle
 */
- (void)teamHandleSelected;

@end
