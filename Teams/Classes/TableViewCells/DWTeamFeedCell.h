//
//  DWTeamFeedCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DWTeamFeedCell;

/**
 * Custom layer for display elements that are drawn
 * via core graphics, mostly used for text
 */
@interface DWTeamFeedCellDrawingLayer : CALayer {
	DWTeamFeedCell *teamCell;
}

/**
 * Non retained reference to the team feed cell
 */
@property (nonatomic,assign) DWTeamFeedCell *teamCell;

@end


/**
 * Represents a team in a list
 */
@interface DWTeamFeedCell : UITableViewCell {	
	
	CALayer							*teamImageLayer;
	DWTeamFeedCellDrawingLayer		*drawingLayer;
	
	BOOL							_highlighted;
    BOOL                            _hasAttachment;
	
	NSString						*_teamName;
	NSString						*_teamData;
	NSString						*_teamDetails;
}

/**
 * Team name
 */
@property (nonatomic,copy) NSString* teamName;

/**
 * Text to be displayed at a team 
 */
@property (nonatomic,copy) NSString* teamData;

/**
 * The address for the team
 */
@property (nonatomic,copy) NSString* teamDetails;

/**
 * Flag for whether the last item at a team had an attachment
 * or not
 */
@property (nonatomic,assign) BOOL hasAttachment;

/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the team image via the teamImageLayer
 */
- (void)setTeamImage:(UIImage*)teamImage;

/**
 * Mark layers for redisplay
 */
- (void)redisplay;

@end

/**
 * Declarations for select private methods
 */
@interface DWTeamFeedCell(Private)
- (void)highlightCell;
- (void)fadeCell;
@end
