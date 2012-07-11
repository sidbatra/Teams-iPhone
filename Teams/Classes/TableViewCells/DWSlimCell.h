//
//  DWSlimCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DWSlimCell;

/**
 * Custom layer for display elements that are drawn
 * via core graphics, mostly used for text
 */
@interface DWSlimCellDrawingLayer : CALayer {
	DWSlimCell *__unsafe_unretained slimCell;
}

/**
 * Non retained reference to the slim cell
 */
@property (nonatomic,unsafe_unretained) DWSlimCell *slimCell;

@end


/**
 * Represents a slim in a cell
 */
@interface DWSlimCell : UITableViewCell {	
	
	CALayer							*imageLayer;
    CALayer                         *chevronLayer;
    CALayer                         *overlayLayer;
	DWSlimCellDrawingLayer          *drawingLayer;
	
	BOOL							_highlighted;
    
    CGRect                          _boldTextRect;
    CGRect                          _plainTextRect;
    CGRect                          _extraTextRect;
    CGRect                          _largeTextRect;
	
	NSString						*_boldText;
    NSString                        *_plainText;
    NSString                        *_extraText;
    NSString                        *_largeText;
}

/**
 * The bold text displayed on the cell
 */
@property (nonatomic,copy) NSString* boldText;

/**
 * The plain text displayed on the cell
 */
@property (nonatomic,copy) NSString* plainText;

/**
 * Extra text displayed on the top right hand side
 */
@property (nonatomic,copy) NSString* extraText;

/**
 * Large text displayed on the left side instead 
 * of the image
 */
@property (nonatomic,copy) NSString* largeText;

/**
 * CGRect's for all the individual text elements
 */
@property (nonatomic,readonly) CGRect boldTextRect;
@property (nonatomic,readonly) CGRect plainTextRect;
@property (nonatomic,readonly) CGRect extraTextRect;
@property (nonatomic,readonly) CGRect largeTextRect;


/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the image via the image layer
 */
- (void)setImage:(UIImage*)image;

/**
 * Display the visited state for the cell
 */
- (void)displayVisitedState;

/**
 * Display the un-visited state for the cell
 */
- (void)displayUnvisitedState;

/**
 * Mark layers for redisplay
 */
- (void)redisplay;

/**
 * Disables the cell interaction
 */
- (void)disableCellInteraction;

@end


/**
 * Declarations for select private methods
 */
@interface DWSlimCell(Private)
- (void)highlightCell;
- (void)fadeCell;
@end
