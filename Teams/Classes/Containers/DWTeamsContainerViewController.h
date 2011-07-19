//
//  DWTeamsContainerViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWContainerViewController.h"

@class DWPopularTeamsViewController;

/**
 * Root view for the teams navigation controller
 */
@interface DWTeamsContainerViewController : DWContainerViewController<UISearchBarDelegate> {
    DWPopularTeamsViewController    *_popularTeamsViewController;
    UISearchBar                     *_searchBar;
}

/**
 * Displays the currently "popular" teams
 */
@property (nonatomic,retain) DWPopularTeamsViewController *popularTeamsViewController;

/**
 * Search bar for issuing global searches
 */
@property (nonatomic,retain) UISearchBar *searchBar;

@end
