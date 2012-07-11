//
//  DWTeamsLogicController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DWTeam;
@class DWTableViewController;
@protocol DWTeamsLogicControllerDelegate;

/**
 * Base table views that display a list of teams
 */
@interface DWTeamsLogicController : NSObject {
    DWTableViewController   *__unsafe_unretained _tableViewController;
    
    BOOL                    _navigationEnabled;
    
    id <DWTeamsLogicControllerDelegate> __unsafe_unretained _delegate;
}

/**
 * The table view controller which contains the teams view controller object
 */
@property (nonatomic,unsafe_unretained) DWTableViewController *tableViewController;

/**
 * Controls the navigation from team cells
 */
@property (nonatomic,assign) BOOL navigationEnabled;

/**
 * Delegate receives events based on the DWTeamsLogicControllerDelegate
 */
@property (nonatomic,unsafe_unretained) id<DWTeamsLogicControllerDelegate> delegate;

@end


/**
 * Delegate protocol for the DWTeamsLogicController
 */
@protocol DWTeamsLogicControllerDelegate

/**
 * Fired when the user selects a team
 */
- (void)teamsLogicTeamSelected:(DWTeam*)team;

@end
