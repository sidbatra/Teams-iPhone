//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"
#import "DWSearchBar.h"
#import "DWSearchViewController.h"

@class DWPopularTeamsViewController;
@class DWNavTitleView;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController<UISearchBarDelegate,DWSearchBarDelegate,DWSearchViewControllerDelegate> {
    
    DWPopularTeamsViewController    *_popularTeamsViewController;
    DWSearchViewController          *_searchViewController;
    
    DWSearchBar                     *_searchBar;
    DWNavTitleView                  *_navTitleView;
}

/**
 * Displays the currently "popular" teams
 */
@property (nonatomic) DWPopularTeamsViewController *popularTeamsViewController;

/**
 * Show results from search queries
 */
@property (nonatomic) DWSearchViewController *searchViewController;

/**
 * Custom search bar
 */
@property (nonatomic) DWSearchBar *searchBar;

/**
 * Title view for the navigation bar
 */
@property (nonatomic) DWNavTitleView *navTitleView;

@end
