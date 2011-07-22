//
//  DWImageCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWImageCell.h"
#import "DWConstants.h"

/**
 * Private method and property declarations
 */
@interface DWImageCell()

/**
 * Add an image view where the image is displayed
 */
- (void)createImageView;

/**
 * Add a label to contain the byline
 */
- (void)createByline;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWImageCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.clipsToBounds = YES;
        
        [self createImageView];
        [self createByline];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createImageView {
    imageView    = [[[UIImageView alloc] initWithFrame:CGRectMake(0,-(320-kImageCellHeight)/2,
                                                                  320,320)] autorelease];
    
    [self.contentView addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createByline {
    bylineLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(0,kImageCellHeight-40,
                                                                                 320,40)] autorelease];
    bylineLabel.backgroundColor     = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    bylineLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:15];	
    bylineLabel.textColor			= [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    bylineLabel.textAlignment		= UITextAlignmentCenter;
    
    [self.contentView addSubview:bylineLabel];
}
//----------------------------------------------------------------------------------------------------
- (void)setByline:(NSString*)byline {
    bylineLabel.text = byline;
}
//----------------------------------------------------------------------------------------------------
- (void)setImage:(UIImage*)image {
    imageView.image = image;
}

@end
