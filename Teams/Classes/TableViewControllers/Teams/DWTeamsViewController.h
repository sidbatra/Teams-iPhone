//
//  DWTeamsViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWTableViewController.h"

@class DWTeamsLogicController;
@protocol DWTeamsLogicControllerDelegate;

/**
 * Base class for all table view that implement only a list of teams
 */
@interface DWTeamsViewController : DWTableViewController {
    DWTeamsLogicController       *_teamsLogicController;
}

/**
 * Teams view controller encapsulates the common display and interaction 
 * functionality needed to display one or more teams
 */
@property (nonatomic) DWTeamsLogicController *teamsLogicController;


/**
 * Set a teams logic controller delegate
 */
- (void)setTeamsDelegate:(id<DWTeamsLogicControllerDelegate>)delegate;

@end