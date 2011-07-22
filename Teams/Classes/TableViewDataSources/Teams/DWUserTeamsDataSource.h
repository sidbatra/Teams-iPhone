//
//  DWUserTeamsDataSource.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTeamsDataSource.h"

/**
 * Data source the user teams view
 */
@interface DWUserTeamsDataSource : DWTeamsDataSource {
    NSInteger   _userID;
}

/**
 * The userID whose teams are being displayed
 */
@property (nonatomic,assign) NSInteger userID;

@end
