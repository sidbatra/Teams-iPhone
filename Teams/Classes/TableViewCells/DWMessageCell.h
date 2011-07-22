//
//  DWMessageCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Display a custom message
 */
@interface DWMessageCell : UITableViewCell {
	UILabel         *messageLabel;
    UIImageView     *chevronView;
    
    BOOL            _interactive;
    BOOL            _highlighted;
}

/**
 * Set a new message on to the message label
 */
- (void)setMessage:(NSString*)message;

/**
 * Interactive mode adds a chevron image and highlights the text
 */
- (void)enableInteractiveMode;

@end
