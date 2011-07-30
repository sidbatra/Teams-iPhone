//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"

@class DWPopularTeamsViewController;
@class DWSearchViewController;
@class DWNavTitleView;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController<UISearchBarDelegate> {
    DWPopularTeamsViewController    *_popularTeamsViewController;
    DWSearchViewController          *_searchViewController;
    
    DWNavTitleView                  *_navTitleView;
    
    UISearchBar                     *_searchBar;
}

/**
 * Displays the currently "popular" teams
 */
@property (nonatomic,retain) DWPopularTeamsViewController *popularTeamsViewController;

/**
 * Show results from search queries
 */
@property (nonatomic,retain) DWSearchViewController *searchViewController;

/**
 * Title view for the navigation bar
 */
@property (nonatomic,retain) DWNavTitleView *navTitleView;

/**
 * Search bar for issuing global searches
 */
@property (nonatomic,retain) UISearchBar *searchBar;

@end
