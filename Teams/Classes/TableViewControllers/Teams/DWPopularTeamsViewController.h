//
//  DWPopularTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTeamsViewController.h"

@class DWPopularTeamsDataSource;

/**
 * Table view for displaying popular teams
 */
@interface DWPopularTeamsViewController : DWTeamsViewController {
    DWPopularTeamsDataSource    *_popularTeamsDataSource;  
}

/**
 * Data source for the table view
 */
@property (nonatomic,retain) DWPopularTeamsDataSource *popularTeamsDataSource;

@end
