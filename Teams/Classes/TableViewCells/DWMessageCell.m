//
//  DWMessageCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMessageCell.h"
#import "DWConstants.h"

#define kColorBgInteractive         [UIColor colorWithRed:0.1098 green:0.1098 blue:0.1098 alpha:1.0]
#define kColorBgInteractiveSelected [UIColor blackColor]

static NSString* const kImgChevron		= @"chevron.png";
static NSString* const kImgSeparator    = @"hr_dark.png";
static CGFloat   const kFadeDelay       = 0.3;


/**
 * Private method and property declarations
 */
@interface DWMessageCell()

/**
 * Create a label to display the message of the cell
 */
- (void)createMessageLabel;

/**
 * Create image view with a chevron image
 */
- (void)createChevron;

/**
 * Add a separator at the end of the cell
 */
- (void)createSeparator;

/**
 * Return the cell back to its normal interactive state
 */
- (void)fadeCell;

/**
 * Highlight the cell when touched
 */
- (void)highlightCell;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMessageCell

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style 
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
	
    if (self) {
		
		[self createMessageLabel];
        [self createChevron];
        [self createSeparator];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;	
	}
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createMessageLabel {
    messageLabel					= [[[UILabel alloc] initWithFrame:CGRectMake(20,-1,
                                                                                 self.contentView.frame.size.width-40,
                                                                                 kMessageCellHeight)] autorelease];
    messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:13];	
    messageLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.25];
    messageLabel.backgroundColor	= [UIColor clearColor];
    messageLabel.textAlignment		= UITextAlignmentCenter;
    
    [self.contentView addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createChevron {
    chevronView             = [[[UIImageView alloc] initWithFrame:CGRectMake(307,28,6,11)] autorelease];
    chevronView.image       = [UIImage imageNamed:kImgChevron];
    chevronView.hidden      = YES;
    
    [self.contentView addSubview:chevronView];
}

//----------------------------------------------------------------------------------------------------
- (void)createSeparator {
    separatorView           = [[[UIImageView alloc] initWithFrame:CGRectMake(0,66,320,1)] autorelease];
    separatorView.image     = [UIImage imageNamed:kImgSeparator];
    separatorView.hidden    = YES;
    
    [self.contentView addSubview:separatorView];
}

//----------------------------------------------------------------------------------------------------
- (void)enableInteractiveMode {
    messageLabel.font                   = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    messageLabel.textColor              = [UIColor whiteColor];
    
    self.contentView.backgroundColor    = kColorBgInteractive;
    
	chevronView.hidden                  = NO;
    separatorView.hidden                = NO;
    _interactive                        = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)highlightCell {
    self.contentView.backgroundColor = kColorBgInteractiveSelected;
    _highlighted = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)fadeCell {
    self.contentView.backgroundColor = kColorBgInteractive;
    _highlighted = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)setMessage:(NSString*)message {
    messageLabel.text = message;
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted 
			  animated:(BOOL)animated {
    
    if(_interactive && highlighted) {
        [self highlightCell];
    }
    else if(_interactive && !highlighted) {
        
        [self performSelector:@selector(fadeCell)
				   withObject:nil 
				   afterDelay:kFadeDelay];
    }
    
}

@end
