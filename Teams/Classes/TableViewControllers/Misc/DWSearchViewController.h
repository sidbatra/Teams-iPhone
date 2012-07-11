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

@protocol DWSearchViewControllerDelegate;

/**
 * Table view displaying search results
 */
@interface DWSearchViewController : DWTableViewController<UISearchBarDelegate,UIScrollViewDelegate> {
    DWUsersLogicController      *_usersLogicController;
    DWTeamsLogicController      *_teamsLogicController;
    DWSearchDataSource          *_searchDataSource;
    
    id<DWSearchViewControllerDelegate>   __unsafe_unretained _delegate;    
}

/**
 * Users view controller encapsulates the common display and interaction 
 * functionality needed to display one or more users
 */
@property (nonatomic) DWUsersLogicController *usersLogicController;

/**
 * Teams view controller encapsulates the common display and interaction 
 * functionality needed to display one or more teams
 */
@property (nonatomic) DWTeamsLogicController *teamsLogicController;

/**
 * Data source for the table view
 */
@property (nonatomic) DWSearchDataSource *searchDataSource;

/**
 * Delegates receives events based on the DWSearchViewControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWSearchViewControllerDelegate> delegate;


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



/**
 * Protocol for delegates of DWSearchViewController instances
 */
@protocol DWSearchViewControllerDelegate

@optional

/**
 * Fired whenever the user interact with table view
 */
- (void)didInteractWithTableView;

/**
 * Fired when the user chooses to invite someone
 */
- (void)invitePeople;

@end



