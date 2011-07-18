//
//  DWTeamFeedCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "DWVideoView.h"

@class DWItemFeedCell;
@protocol DWItemFeedCellDelegate;

/**
 * Custom layer for display elements that are drawn
 * via core graphics, mostly used for text
 */
@interface DWItemFeedCellDrawingLayer : CALayer {
	DWItemFeedCell	*itemCell;
}

/**
 * Non retained reference to the item feed cell
 */
@property (nonatomic,assign) DWItemFeedCell *itemCell;

@end


/**
 * Cell used in item feed view controller
 */
@interface DWItemFeedCell : UITableViewCell<DWVideoViewDelegate,UIGestureRecognizerDelegate> {
	
	CALayer							*itemImageLayer;
	CALayer							*touchIconImageLayer;
	CALayer							*playImageLayer;
	CALayer							*shareImageLayer;
    

	DWItemFeedCellDrawingLayer		*drawingLayer;

	
	BOOL							_highlighted;
    BOOL                            _isTouching;
	BOOL							_teamButtonPressed;
	BOOL							_userButtonPressed;
    BOOL                            _teamButtonDisabled;
    BOOL                            _userButtonDisabled;
    BOOL                            _bylineMode;
	
	NSInteger						_itemID;
	NSInteger						_itemTouchesCount;
	NSInteger						_attachmentType;
	
	NSString						*_itemData;
	NSString						*_itemTeamName;
	NSString						*_itemUserName;
	NSString						*_itemCreatedAt;
	NSString						*_itemDetails;
    NSString                        *_itemTouchesCountString;
    NSString                        *_byline;
	
	NSDate							*_highlightedAt;

	CGRect							_userNameRect;
	CGRect							_atRect;
	CGRect							_teamNameRect;
	CGRect							_dataRect;
    CGRect                          _touchesCountRect;
    CGRect                          _createdAtRect;
    CGRect                          _bylineRect;

	
	UIButton						*teamButton;
	UIButton						*userButton;
	UIButton						*shareButton;
    
    DWVideoView                     *videoView;
	
	id<DWItemFeedCellDelegate>		_delegate;
}


@property (nonatomic,assign) NSInteger itemID;
@property (nonatomic,assign) NSInteger attachmentType;

@property (nonatomic,readonly) BOOL teamButtonPressed;
@property (nonatomic,readonly) BOOL userButtonPressed;
@property (nonatomic,readonly) BOOL isTouching;
@property (nonatomic,readonly) BOOL teamButtonDisabled;
@property (nonatomic,readonly) BOOL userButtonDisabled;
@property (nonatomic,readonly) BOOL bylineMode;

@property (nonatomic,copy) NSString* itemData;
@property (nonatomic,copy) NSString* itemTeamName;
@property (nonatomic,copy) NSString* itemUserName;
@property (nonatomic,copy) NSString* itemCreatedAt;
@property (nonatomic,copy) NSString* itemDetails;
@property (nonatomic,copy) NSString* itemTouchesCountString;
@property (nonatomic,copy) NSString* byline;

@property (nonatomic,retain) NSDate* highlightedAt;

@property (nonatomic,readonly) CGRect userNameRect;
@property (nonatomic,readonly) CGRect atRect;
@property (nonatomic,readonly) CGRect teamNameRect;
@property (nonatomic,readonly) CGRect dataRect;
@property (nonatomic,readonly) CGRect touchesCountRect;
@property (nonatomic,readonly) CGRect createdAtRect;
@property (nonatomic,readonly) CGRect bylineRect;



@property (nonatomic,assign) id<DWItemFeedCellDelegate> delegate;


/**
 * Reset any variables that may not be refreshed 
 */
- (void)reset;

/**
 * Set the item image
 */
- (void)setItemImage:(UIImage*)itemImage;

/**
 * Set item details - touchesCount and createdAtString
 */
- (void)setDetails:(NSInteger)touchesCount 
	  andCreatedAt:(NSString*)createdAt;

/**
 * Display the UI and events for the user button
 */
- (void)setUserButtonAsDisabled;

/**
 * Display the UI and events for the team button
 */
- (void)setTeamButtonAsDisabled;

/**
 * Convert the cell into byline mode
 */
- (void)setupBylineMode:(NSString*)byline;

/**
 * Sets the cell to be rerendered
 */
- (void)redisplay;

@end


/**
 * Declarations for select private methods
 */
@interface DWItemFeedCell(Private)
- (void)highlightCell;
- (void)fadeCell;
- (void)touchCell;
- (void)finishTouchCell;
@end


/**
 * Delegate protocol to send events about cell interactions
 */
@protocol DWItemFeedCellDelegate
- (BOOL)shouldTouchItemWithID:(NSInteger)itemID;
- (void)cellTouched:(NSInteger)itemID;
- (void)teamSelectedForItemID:(NSInteger)itemID;
- (void)userSelectedForItemID:(NSInteger)itemID;
- (void)shareSelectedForItemID:(NSInteger)itemID;
- (NSString*)getVideoAttachmentURLForItemID:(NSInteger)itemID;
@end
