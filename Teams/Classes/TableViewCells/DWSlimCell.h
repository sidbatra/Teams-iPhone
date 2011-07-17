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
	DWSlimCell *slimCell;
}

/**
 * Non retained reference to the slim cell
 */
@property (nonatomic,assign) DWSlimCell *slimCell;

@end


/**
 * Represents a slim in a cell
 */
@interface DWSlimCell : UITableViewCell {	
	
	CALayer							*imageLayer;
    CALayer                         *chevronLayer;
	DWSlimCellDrawingLayer          *drawingLayer;
	
	BOOL							_highlighted;
    
    CGRect                          _boldTextRect;
    CGRect                          _plainTextRect;
	
	NSString						*_boldText;
    NSString                        *_plainText;
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
 * CGRect's for all the individual text elements
 */
@property (nonatomic,readonly) CGRect boldTextRect;
@property (nonatomic,readonly) CGRect plainTextRect;


/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the image via the image layer
 */
- (void)setImage:(UIImage*)image;

/**
 * Mark layers for redisplay
 */
- (void)redisplay;

@end


/**
 * Declarations for select private methods
 */
@interface DWSlimCell(Private)
- (void)highlightCell;
- (void)fadeCell;
@end
