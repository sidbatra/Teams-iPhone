//
//  DWUserViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"
#import "DWUserViewDataSource.h"

/**
 * Display the user profile
 */
@interface DWUserViewController : DWTableViewController<DWUserViewDataSourceDelegate> {
    DWUserViewDataSource    *_userViewDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWUserViewDataSource   *userViewDataSource;


/**
 * Init with the user id whose profile is to be displayed
 */
- (id)initWithUserID:(NSInteger)userID;

@end
