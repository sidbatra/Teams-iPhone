//
//  DWFatCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWFatCell.h"
#import "DWConstants.h"

/**
 * Private method and property declarations
 */
@interface DWFatCell()

/**
 * Add an image view where the image is displayed
 */
- (void)createImageView;

/**
 * Add a label to contain the firstline
 */
- (void)createFirstLine;

/**
 * Add a label to contain the secondline
 */
- (void)createSecondLine;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWFatCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
        self.clipsToBounds          = YES;
        self.userInteractionEnabled = NO;
        
        [self createImageView];
        [self createFirstLine];
        [self createSecondLine];
        
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
    imageView    = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,275)] autorelease];
    
    [self.contentView addSubview:imageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createFirstLine {
    firstLineLabel                      = [[[UILabel alloc] initWithFrame:CGRectMake(22,225,280,28)] autorelease];
    firstLineLabel.backgroundColor      = [UIColor clearColor];
    firstLineLabel.font                 = [UIFont fontWithName:@"HelveticaNeue" size:22];	
    firstLineLabel.textColor			= [UIColor whiteColor];
    firstLineLabel.textAlignment		= UITextAlignmentLeft;
    firstLineLabel.lineBreakMode        = UILineBreakModeTailTruncation;
    
    [self.contentView addSubview:firstLineLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createSecondLine {
    secondLineLabel                     = [[[UILabel alloc] initWithFrame:CGRectMake(22,250,280,28)] autorelease];
    secondLineLabel.backgroundColor     = [UIColor clearColor];
    secondLineLabel.font                = [UIFont fontWithName:@"HelveticaNeue" size:15];	
    secondLineLabel.textColor			= [UIColor whiteColor];
    secondLineLabel.textAlignment		= UITextAlignmentLeft;
    secondLineLabel.lineBreakMode       = UILineBreakModeTailTruncation;
    
    [self.contentView addSubview:secondLineLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setFirstLine:(NSString*)firstLine {
    firstLineLabel.text = firstLine;
}

//----------------------------------------------------------------------------------------------------
- (void)setSecondLine:(NSString*)secondLine {
    secondLineLabel.text = secondLine;
}

//----------------------------------------------------------------------------------------------------
- (void)setImage:(UIImage*)image {
    imageView.image = image;
}

@end
