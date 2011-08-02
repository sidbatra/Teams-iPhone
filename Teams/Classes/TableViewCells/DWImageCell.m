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

    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createByline {
    UILabel *background             = [[[UILabel alloc] initWithFrame:CGRectMake(0,kImageCellHeight-47,
                                                                                 320,47)] autorelease];
    background.backgroundColor      = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [self.contentView addSubview:background];
    
    
    bylineLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(7,kImageCellHeight-47-1,
                                                                                 320-14,47)] autorelease];
    bylineLabel.backgroundColor     = [UIColor clearColor];
    bylineLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:15];	
    bylineLabel.textColor			= [UIColor whiteColor];
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
