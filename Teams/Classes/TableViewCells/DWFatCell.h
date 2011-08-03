//
//  DWFatCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Display an background image with double line text
 */
@interface DWFatCell : UITableViewCell {
    UIImageView     *imageView;
    UILabel         *firstLineLabel;
    UILabel         *secondLineLabel;
}

/**
 * Set the first line of text
 */
- (void)setFirstLine:(NSString*)firstLine;

/**
 * Set the second line of text
 */
- (void)setSecondLine:(NSString*)secondLine;

/**
 * Apply an image
 */
- (void)setImage:(UIImage*)image;

@end
