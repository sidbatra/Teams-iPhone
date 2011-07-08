//
//  DWItem.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"
#import "DWAttachment.h"
#import "DWTeam.h"
#import "DWUser.h"

/**
 * Item model represent iteam posted by the user. 
 */
@interface DWItem : DWPoolObject {	
	NSString		*_data;
	
	DWAttachment	*_attachment;
	DWTeam			*_team;
	DWUser			*_user;
	
    NSInteger		_touchesCount;
	BOOL			_isTouched;
	NSTimeInterval	_createdAtTimestamp;
}

/**
 * Data associated with the item in its condensed state
 * where URLs have been shortened
 */
@property (nonatomic,copy) NSString *data;

/**
 * Attachment associated with the item
 */
@property (nonatomic,retain) DWAttachment *attachment;

/**
 * Team to which the item belongs
 */
@property (nonatomic,retain) DWTeam *team;

/** 
 * The user who created the item
 */ 
@property (nonatomic,retain) DWUser *user;

/**
 * Total touches on the item
 */
@property (nonatomic,readonly) NSInteger touchesCount;

/**
 * Item has been touched by the current user or not
 */
@property (nonatomic,assign) BOOL isTouched;

/**
 * Timestamp of the date of creation of the item
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;


/**
 * Launch download of the images needed to display the item
 */
- (void)startImagesDownload;

@end

