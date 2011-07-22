//
//  DWImageCell.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Display an image along with an optional byline
 */
@interface DWImageCell : UITableViewCell {
    UIImageView     *imageView;
    UILabel         *bylineLabel;
}

/**
 * Apply a byline
 */
- (void)setByline:(NSString*)byline;

/**
 * Apply an image
 */
- (void)setImage:(UIImage*)image;

@end
