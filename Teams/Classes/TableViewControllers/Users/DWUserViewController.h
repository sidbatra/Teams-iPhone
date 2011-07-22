//
//  DWUserViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWUserViewDataSource.h"

@class DWTeam;
@class DWNavTitleView;
@protocol DWUserViewControllerDelegate;

/**
 * Display the user profile
 */
@interface DWUserViewController : DWTableViewController<DWUserViewDataSourceDelegate> {
    DWUserViewDataSource    *_userViewDataSource;
    DWNavTitleView          *_navTitleView;
    
    id<DWUserViewControllerDelegate>    _delegate;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWUserViewDataSource   *userViewDataSource;

/**
 * Title view for the nav bar
 */ 
@property (nonatomic,retain) DWNavTitleView *navTitleView;

/**
 * Delegate receives events based on DWUserViewControllerDelegate
 */
@property (nonatomic,assign) id<DWUserViewControllerDelegate> delegate;


/**
 * Init with the user id whose profile is to be displayed
 */
- (id)initWithUserID:(NSInteger)userID;

@end


/**
 * Protocol for delegates of DWUserViewController instances
 */
@protocol DWUserViewControllerDelegate

/**
 * Display the team of the user
 */
- (void)userViewShowTeam:(DWTeam*)team;

/**
 * Display the teams watched by the given user
 */
- (void)userViewShowTeamsWatchedBy:(DWUser*)user;

@end

