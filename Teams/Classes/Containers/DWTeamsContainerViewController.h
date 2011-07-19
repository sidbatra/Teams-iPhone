//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"

@class DWPopularTeamsViewController;
@class DWSearchViewController;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController<UISearchBarDelegate> {
    DWPopularTeamsViewController    *_popularTeamsViewController;
    DWSearchViewController          *_searchViewController;
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
 * Search bar for issuing global searches
 */
@property (nonatomic,retain) UISearchBar *searchBar;

@end
