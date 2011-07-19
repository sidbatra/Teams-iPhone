//
//  DWDoubleLineCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Forms the background view of a selected place search result cell
 */
@interface DWDoubleLineSelectedView : UIView {
}

@end


/**
 * Forms the background view of a double line cell
 */
@interface DWDoubleLineView : UIView {
	NSString	*_firstLine;
	NSString	*_secondLine;
	
	BOOL		_highlighted;
}


/**
 * First line
 */
@property (nonatomic,copy) NSString* firstLine;

/**
 * Second line
 */
@property (nonatomic,copy) NSString* secondLine;

/**
 * Reset any variables that may not be refreshed - eg : _highlight
 */
- (void)reset;

/**
 * Set the view to redraw when visible content has
 * been modified
 */
- (void)redisplay;

@end


/**
 * Cell for displaying place search results
 */
@interface DWDoubleLineCell : UITableViewCell {
	DWDoubleLineView *_doubleLineView;
}

/**
 * Primary view for drawing content
 */
@property (nonatomic,retain) DWDoubleLineView *doubleLineView;


/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the text for first line
 */
- (void)setFirstLine:(NSString*)firstLine;

/**
 * Set the text for second line
 */ 
- (void)setSecondLine:(NSString*)secondLine;


/**
 * Sets the cell to be rerendered
 */
- (void)redisplay;

@end
