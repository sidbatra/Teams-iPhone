//
//  DWTeamFeedCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamFeedCell.h"

static NSString* const kImgSeparator	= @"hr_dark.png";
static NSString* const kImgChevron		= @"chevron.png";

#define kAnimationDuration              0.05
#define kNoAnimationDuration            0.0
#define kFadeDelay                      0.3
#define kNormalAlpha                	0.5
#define kNormalNoAttachmentAlpha        1.0
#define kHighlightAlpha                 0.35
#define kColorNormalBg                  [UIColor colorWithRed:0.2627 green:0.2627 blue:0.2627 alpha:1.0].CGColor
#define kColorNoAttachmentBg            [UIColor colorWithRed:0.3490 green:0.3490 blue:0.3490 alpha:1.0].CGColor
#define kColorNoAttachmentHighlightBg   [UIColor colorWithRed:0.2784 green:0.2784 blue:0.2784 alpha:1.0].CGColor



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamFeedCellDrawingLayer

@synthesize teamCell;

//----------------------------------------------------------------------------------------------------
- (void)drawInContext:(CGContextRef)context {
	
	UIGraphicsPushContext(context);
	
	if([teamCell isHighlighted] && !teamCell.hasAttachment)
        CGContextSetFillColorWithColor(context,[UIColor colorWithRed:0.9019
                                                               green:0.9019 
                                                                blue:0.9019
                                                               alpha:1.0].CGColor);	 
    else
        CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);	 
	
	[teamCell.teamName drawInRect:CGRectMake(20,21,280,28) 
						   withFont:[UIFont fontWithName:@"HelveticaNeue" size:22]
					  lineBreakMode:UILineBreakModeTailTruncation
						  alignment:UITextAlignmentLeft];
	 
	[teamCell.teamDetails drawInRect:CGRectMake(20,49,280,20)
							  withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] 
						 lineBreakMode:UILineBreakModeTailTruncation
							 alignment:UITextAlignmentLeft];
	
	UIGraphicsPopContext();
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamFeedCell

@synthesize teamName			= _teamName;
@synthesize teamData			= _teamData;
@synthesize teamDetails		= _teamDetails;
@synthesize hasAttachment       = _hasAttachment;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
    
	if (self) {
        
		CGRect frame = CGRectMake(0,0,320,92);
        _animationEnabled = YES;
		
		teamImageLayer					= [CALayer layer];
		teamImageLayer.frame			= frame;
		teamImageLayer.contentsScale	= [[UIScreen mainScreen] scale];
		teamImageLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSNull null], @"contents",
										   nil];
		[[self layer] addSublayer:teamImageLayer];
		
		drawingLayer					= [DWTeamFeedCellDrawingLayer layer];
		drawingLayer.teamCell			= self;
		drawingLayer.frame				= frame;
		drawingLayer.contentsScale		= [[UIScreen mainScreen] scale];
		drawingLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSNull null], @"contents",
										   nil];
        [[self layer] addSublayer:drawingLayer];
		
		chevronLayer                    = [CALayer layer];
		chevronLayer.frame				= CGRectMake(307,41,6,11);
		chevronLayer.contentsScale		= [[UIScreen mainScreen] scale];
		chevronLayer.contents			= (id)[UIImage imageNamed:kImgChevron].CGImage;
		[[self layer] addSublayer:chevronLayer];
		
		CALayer *separatorLayer			= [CALayer layer];
		separatorLayer.frame			= CGRectMake(0,91,320,1);
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
	self.teamName		= nil;
	self.teamDetails	= nil;
	self.teamData		= nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	_highlighted = NO;
    
    [CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kNoAnimationDuration]
					 forKey:kCATransactionAnimationDuration];		
    
	teamImageLayer.opacity         = _hasAttachment ? kNormalAlpha : kNormalNoAttachmentAlpha;
    teamImageLayer.backgroundColor = _hasAttachment ? kColorNormalBg : kColorNoAttachmentBg;
    
	[CATransaction commit];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted 
			  animated:(BOOL)animated {
	
    if(!_animationEnabled)
        return;
    
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
- (void)setTeamImage:(UIImage*)teamImage {
	teamImageLayer.contents = (id)teamImage.CGImage;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[drawingLayer setNeedsDisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)hideChevron {
    chevronLayer.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)disableAnimation {
    _animationEnabled = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)highlightCell {
	_highlighted = YES;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kAnimationDuration]
					 forKey:kCATransactionAnimationDuration];		
	teamImageLayer.opacity         = _hasAttachment ? kHighlightAlpha : kNormalNoAttachmentAlpha;
    teamImageLayer.backgroundColor = _hasAttachment ? kColorNormalBg : kColorNoAttachmentHighlightBg;
    [self redisplay];
	[CATransaction commit];
}

//----------------------------------------------------------------------------------------------------
- (void)fadeCell {
	_highlighted = NO;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kAnimationDuration]
					 forKey:kCATransactionAnimationDuration];		
	teamImageLayer.opacity         = _hasAttachment ? kNormalAlpha : kNormalNoAttachmentAlpha;
    teamImageLayer.backgroundColor = _hasAttachment ? kColorNormalBg : kColorNoAttachmentBg;
    [self redisplay];
	[CATransaction commit];
}


@end
