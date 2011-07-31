//
//  DWSlimCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSlimCell.h"
#import "DWConstants.h"

static NSString* const kImgSeparator	= @"hr_dark.png";
static NSString* const kImgChevron		= @"chevron.png";


#define kAnimationDuration          0.05
#define kNoAnimationDuration		0.0
#define kFadeDelay                  0.3
#define kColorNormalBg              [UIColor colorWithRed:0.2588 green:0.2588 blue:0.2627 alpha:1.0].CGColor
#define kColorHighlightBg           [UIColor colorWithRed:0.2784 green:0.2784 blue:0.2784 alpha:1.0].CGColor
#define kColorTextBold              [UIColor whiteColor].CGColor
#define kColorTextPlain             [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5].CGColor
#define kFontBoldText               [UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
#define kFontPlainText              [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kTextX                      58
#define kTextY                      15



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSlimCellDrawingLayer

@synthesize slimCell;

//----------------------------------------------------------------------------------------------------
- (void)drawInContext:(CGContextRef)context {
	
	UIGraphicsPushContext(context);
	
	
	CGContextSetFillColorWithColor(context,kColorTextBold);
    
    [slimCell.boldText drawInRect:slimCell.boldTextRect
                         withFont:kFontBoldText
                    lineBreakMode:UILineBreakModeTailTruncation];
    
    
    CGContextSetFillColorWithColor(context,kColorTextPlain);
    
    [slimCell.plainText drawInRect:slimCell.plainTextRect
                         withFont:kFontPlainText
                     lineBreakMode:UILineBreakModeTailTruncation];
    
    
	UIGraphicsPopContext();
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSlimCell

@synthesize boldText			= _boldText;
@synthesize plainText           = _plainText;
@synthesize boldTextRect        = _boldTextRect;
@synthesize plainTextRect       = _plainTextRect;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
    
	if (self) {
        
        self.clipsToBounds  = YES;
		CGRect frame        = CGRectMake(0,0,320,47);
		
		drawingLayer					= [DWSlimCellDrawingLayer layer];
		drawingLayer.slimCell			= self;
		drawingLayer.frame				= frame;
		drawingLayer.contentsScale		= [[UIScreen mainScreen] scale];
		drawingLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSNull null], @"contents",
										   nil];
        [[self layer] addSublayer:drawingLayer];
        
        imageLayer					= [CALayer layer];
		imageLayer.frame			= CGRectMake(0,0,47,47);
		imageLayer.contentsScale	= [[UIScreen mainScreen] scale];
		imageLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSNull null], @"contents",
                                       nil];
		[[self layer] addSublayer:imageLayer];
		
		chevronLayer                    = [CALayer layer];
		chevronLayer.frame				= CGRectMake(307,18,6,11);
		chevronLayer.contentsScale		= [[UIScreen mainScreen] scale];
		chevronLayer.contents			= (id)[UIImage imageNamed:kImgChevron].CGImage;
		[[self layer] addSublayer:chevronLayer];
		
		CALayer *separatorLayer			= [CALayer layer];
		separatorLayer.frame			= CGRectMake(0,46,320,1);
		separatorLayer.contentsScale	= [[UIScreen mainScreen] scale];
		separatorLayer.contents			= (id)[UIImage imageNamed:kImgSeparator].CGImage;
		[[self layer] addSublayer:separatorLayer];
		
		
		self.accessoryType				= UITableViewCellAccessoryNone;
		self.selectionStyle				= UITableViewCellSelectionStyleNone;
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.boldText       = nil;
	self.plainText		= nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	_highlighted            = NO;
    
    CGSize boldTextSize     = [self.boldText sizeWithFont:kFontBoldText 
                                        constrainedToSize:CGSizeMake(225,20)
                                            lineBreakMode:UILineBreakModeTailTruncation];
    
    _boldTextRect           = CGRectMake(kTextX,
                                         kTextY,
                                         boldTextSize.width,
                                         boldTextSize.height);
    
    CGSize plainTextSize    = [self.plainText sizeWithFont:kFontPlainText
                                         constrainedToSize:CGSizeMake(225-boldTextSize.width,20) 
                                             lineBreakMode:UILineBreakModeTailTruncation];
    
    _plainTextRect           = CGRectMake(kTextX + boldTextSize.width + 5,
                                         kTextY,
                                         plainTextSize.width,
                                         plainTextSize.height);
    
    
    [CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kNoAnimationDuration]
					 forKey:kCATransactionAnimationDuration];		
    
    drawingLayer.backgroundColor = kColorNormalBg;
    
	[CATransaction commit];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted 
			  animated:(BOOL)animated {
    
	if(highlighted && !_highlighted) {
		[self highlightCell];
	}
	else if(!highlighted && _highlighted) {
        
		[self performSelector:@selector(fadeCell)
				   withObject:nil 
				   afterDelay:kFadeDelay];
	}
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isHighlighted {
    return _highlighted;
}

//----------------------------------------------------------------------------------------------------
- (void)setImage:(UIImage*)image {
	imageLayer.contents = (id)image.CGImage;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[drawingLayer setNeedsDisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)highlightCell {
	_highlighted = YES;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kAnimationDuration]
					 forKey:kCATransactionAnimationDuration];		
    
    drawingLayer.backgroundColor = kColorHighlightBg;
    
	[CATransaction commit];
}

//----------------------------------------------------------------------------------------------------
- (void)fadeCell {
	_highlighted = NO;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kAnimationDuration]
					 forKey:kCATransactionAnimationDuration];	
	
    drawingLayer.backgroundColor = kColorNormalBg;
    
	[CATransaction commit];
}

@end
