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
        self.clipsToBounds                  = YES;
        self.contentView.backgroundColor    = [UIColor blackColor];
        
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
    imageView    = [[[UIImageView alloc] initWithFrame:CGRectMake(60,36,200,200)] autorelease];

    imageView.contentMode   = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [[imageView layer] setCornerRadius:4.0];
    
    [self.contentView addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createByline {
    
    bylineLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(7,235,306,46)] autorelease];
    bylineLabel.backgroundColor     = [UIColor clearColor];
    bylineLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:15];	
    bylineLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
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
