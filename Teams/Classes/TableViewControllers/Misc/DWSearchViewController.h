//
//  DWSearchViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWUsersLogicController;
@class DWTeamsLogicController;
@class DWSearchDataSource;
@protocol DWUsersLogicControllerDelegate;
@protocol DWTeamsLogicControllerDelegate;

/**
 * Table view displaying search results
 */
@interface DWSearchViewController : DWTableViewController<UISearchBarDelegate> {
    DWUsersLogicController      *_usersLogicController;
    DWTeamsLogicController      *_teamsLogicController;
    DWSearchDataSource          *_searchDataSource;
}

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic,retain) DWUsersLogicController *usersLogicController;

/**
 * Teams view controller encapsulates the common display and interaction 
 * functionality needed to display one or more teams
 */
@property (nonatomic,retain) DWTeamsLogicController *teamsLogicController;

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWSearchDataSource *searchDataSource;


/**
 * Set a users logic controller delegate
 */
- (void)setUsersDelegate:(id<DWUsersLogicControllerDelegate>)delegate;

/**
 * Set a teams logic controller delegate
 */
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate;

/**
 * Launch a search query
 */
- (void)search:(NSString*)query;

/**
 * Reset the table view to an empty state with or without a spinner
 */
- (void)resetWithSpinnerHidden:(BOOL)isSpinning;

@end
