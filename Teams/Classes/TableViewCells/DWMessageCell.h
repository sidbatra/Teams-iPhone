//
//  DWMessageCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Display a custom message
 */
@interface DWMessageCell : UITableViewCell {
	UILabel		*messageLabel;
}

/**
 * Set a new message on to the message label
 */
- (void)setMessage:(NSString*)message;

@end
