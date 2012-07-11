//
//  DWUserTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTeamsViewController.h"

@class DWUser;
@class DWUserTeamsDataSource;

/**
 * Display the teams followed by a user
 */
@interface DWUserTeamsViewController : DWTeamsViewController {
    DWUserTeamsDataSource   *_userTeamsDataSource;
}

/**
 * Data source for the table view
 */
@property (nonatomic) DWUserTeamsDataSource *userTeamsDataSource;


/**
 * Init with user whose teams are being displayed
 */
- (id)initWithUser:(DWUser*)user 
         andIgnore:(BOOL)ignore;

@end
