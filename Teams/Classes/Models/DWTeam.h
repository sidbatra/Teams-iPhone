//
//  DWTeam.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DWPoolObject.h"

@class DWAttachment;

/**
 * Team model representing a group of user's who work together
 */
@interface DWTeam : DWPoolObject<NSCoding> {
	NSString		*_name;
    NSString		*_handle;
    NSString		*_byline;
    NSString        *_eventText;
	
    NSInteger		_followersCount;
    NSInteger		_membersCount;
    
    NSTimeInterval	_createdAtTimestamp;
    
	DWAttachment	*_attachment;
}

/**
 * Name of the team
 */
@property (nonatomic,copy) NSString *name;

/**
 * Handle used in URLs
 */
@property (nonatomic,copy) NSString *handle;

/**
 * Byline of the team
 */
@property (nonatomic,copy) NSString *byline;

/**
 * Text of the most recent event about the team
 */
@property (nonatomic,copy) NSString *eventText;

/**
 * Total users following the team
 */
@property (nonatomic,readonly) NSInteger followingsCount;

/**
 * Total members of the team
 */ 
@property (nonatomic,assign) NSInteger membersCount;

/**
 * Timestamp of the creation of the team
 */
@property (nonatomic,readonly) NSTimeInterval createdAtTimestamp;

/**
 * Optional attachment of the last item posted by the team
 */
@property (nonatomic,retain) DWAttachment *attachment;

 
/**
 * Start downloading the attachment slice image
 */
- (void)startImageDownload;

/**
 * Start downloading the attachment large image
 */
- (void)startLargeImageDownload;

@end


