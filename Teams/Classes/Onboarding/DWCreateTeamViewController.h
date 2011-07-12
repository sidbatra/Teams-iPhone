//
//  DWCreateTeamViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWNavTitleView.h"
#import "DWNavRightBarButtonView.h"

@protocol DWCreateNewTeamViewControllerDelegate;


/**
 * Provides an interface for creating a new team.
 */
@interface DWCreateTeamViewController : UIViewController<DWNavTitleViewDelegate> {
    UITextField                 *_teamNameTextField;
	UITextField                 *_teamBylineTextField;
    
    DWNavTitleView              *_navTitleView;
    DWNavRightBarButtonView     *_navRightBarButtonView;
    
    id<DWCreateNewTeamViewControllerDelegate>   _delegate;
}

/**
 * Custom subviews for navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;
@property (nonatomic,retain) DWNavRightBarButtonView *navRightBarButtonView;

/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UITextField *teamNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *teamBylineTextField;

/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;

@end


/**
 * Delegate protocol to receive events during 
 * the create new team lifecycle
 */
@protocol DWCreateNewTeamViewControllerDelegate

/*
 * Fired when a new team is created.
 */
- (void)newTeamCreated;

@end