//
//  DWItemFeedCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemFeedCell.h"
#import "DWVideoView.h"
#import "DWConstants.h"

#define kImgTouchIcon                       @"hand.png"
#define kImgTouchIcon230                    @"hand.png"
#define kImgTouched                         @"touched.png"
#define kImgPlay                            @"icon_video.png"
#define kImgShare                           @"share.png"
#define kImgShare230                        @"share.png"
#define kImgHalo                            @"halo.png"
#define kImgSeparator                       @"hr_dark.png"
#define kOpacityImagesWithAttachment        1.0
#define kOpacityImagesNoAttachment          0.5
#define kColorAttachmentBg                  [UIColor colorWithRed:0.2627 green:0.2627 blue:0.2627 alpha:1.0].CGColor
#define kColorNoAttachmentBg                [UIColor colorWithRed:0.8000 green:0.8000 blue:0.8000 alpha:1.0].CGColor
#define kColorNoAttachmentHighlightBg       [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0].CGColor
#define kColorLinkPressedWithAttachment     [UIColor colorWithRed:0.8000 green:0.8000 blue:0.8000 alpha:1.0].CGColor
#define kColorLinkPressedNoAttachment       [UIColor colorWithRed:0.6000 green:0.6000 blue:0.6000 alpha:1.0].CGColor
#define kColorTextWithAttachment            [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0].CGColor
#define kColorTextNoAttachment              [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:0.75].CGColor
#define kColorTextHighlightedNoAttachment   [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0].CGColor
#define kColorSubTextNoAttachment           [UIColor colorWithRed:0.4980 green:0.4980 blue:0.4980 alpha:1.0].CGColor
#define kColorByLineWithAttachment          [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:1.0].CGColor
#define kColorByLineNoAttachment            [UIColor colorWithRed:1.0000 green:1.0000 blue:1.0000 alpha:0.5].CGColor
#define kFontItemUserName                   [UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
#define kFontItemUserNameDisabled           [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontAt                             [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontItemTeamName                   [UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
#define kFontItemTeamNameMuted              [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontItemTeamNameDisabled           [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontByline                         [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontItemData                       [UIFont fontWithName:@"HelveticaNeue" size:23]
#define kFontItemCreatedAt                  [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kFontItemTouchesCount               [UIFont fontWithName:@"HelveticaNeue" size:15]
#define kItemUserNameX                      20
#define kItemUserNameY                      13
#define kBylineY                            13
#define kUnderlineYOffset                   17
#define kUnderlineHeight                    0.75
#define kAtXOffset                          0
#define kAtWidth                            2
#define kByLineXOffset                      5
#define kTeamNameXOffset                    2
#define kMaxTeamNameWidth                   305
#define kItemDataX                          30
#define kItemDataXSubTitleOffset            10
#define kItemDataY                          40
#define kItemDataYOffset                    2
#define kItemDataYSubtitleOffset            55
#define kItemDataWidth                      270
#define kItemDataHeight                     240
#define kItemDataSubtitleHeightThreshold    56
#define kDetailsX                           20
#define kDetailsY                           285
#define kTouchesIconXOffset                 4
#define kTouchesIconY                       287
#define kTouchesIconWidth                   14
#define kTouchesIconHeight                  16
#define kDefaultTextHeight                  20
#define kNormalAlpha                        0.60
#define kHighlightAlpha                     1.0
#define kNoAttachmentAlpha                  1.0
#define kSelectionDelay                     0.45
#define kTouchInterval                      0.6
#define kAfterTouchFadeInerval              1.0
#define kNormalFadeInterval                 0.5
#define kNoAnimationDuration                0.0
#define kCellAnimationDuration              0.12
#define kPlayIconXOffset                    0
#define kPlayIconY                          289
#define kPlayIconWidth                      18
#define kPlayIconHeight                     11



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemFeedCellDrawingLayer

@synthesize itemCell;

//----------------------------------------------------------------------------------------------------
- (id<CAAction>)actionForKey:(NSString *)key {
	
	if([key isEqualToString:@"contents"] && (itemCell.userButtonPressed || itemCell.teamButtonPressed))
        return nil;
    
	return [super actionForKey:key];
}

//----------------------------------------------------------------------------------------------------
- (void)drawInContext:(CGContextRef)context {
	
	UIGraphicsPushContext(context);
    
    BOOL isTextOnly = [itemCell attachmentType] == kAttachmentNone;
    
    CGColorRef textColor    = isTextOnly ? kColorTextNoAttachment : kColorTextWithAttachment;
    CGColorRef subTextColor = isTextOnly ? kColorSubTextNoAttachment : textColor;
    
	
	if(![itemCell isHighlighted]) {
		
        
        if(!itemCell.bylineMode) {
        
            //----------------------------------
            CGColorRef userColor = itemCell.userButtonPressed ? 
                                    (isTextOnly ? kColorLinkPressedNoAttachment : kColorLinkPressedWithAttachment) : 
                                    textColor;
            
            CGContextSetFillColorWithColor(context,userColor);
            
            [itemCell.itemUserName drawInRect:itemCell.userNameRect 
                                     withFont:itemCell.userButtonDisabled ? kFontItemUserNameDisabled : kFontItemUserName];
            
            if(![itemCell userButtonDisabled])
                CGContextFillRect(context,CGRectMake(itemCell.userNameRect.origin.x,
                                                     itemCell.userNameRect.origin.y+kUnderlineYOffset,
                                                     itemCell.userNameRect.size.width-1,
                                                     kUnderlineHeight));
            
            
            //----------------------------------
            CGContextSetFillColorWithColor(context,textColor);
            
            [@"" drawInRect:itemCell.atRect
                     withFont:kFontAt];
            
        }
        else {
            
            CGColorRef bylineTextColor = isTextOnly ? kColorByLineNoAttachment : kColorByLineWithAttachment;

            CGContextSetFillColorWithColor(context,bylineTextColor);
            
            [itemCell.byline drawInRect:itemCell.bylineRect
                               withFont:kFontByline
                          lineBreakMode:UILineBreakModeTailTruncation];
        }
		
		
		//----------------------------------	
        CGColorRef teamColor = itemCell.teamButtonPressed ? 
                                (isTextOnly ? kColorLinkPressedNoAttachment : kColorLinkPressedWithAttachment) : 
                                textColor;
        
		CGContextSetFillColorWithColor(context,teamColor);
		
		
		[itemCell.itemTeamName drawInRect:itemCell.teamNameRect
                                 withFont:itemCell.teamButtonDisabled ? kFontItemTeamNameDisabled : (itemCell.byline ? kFontItemTeamName : kFontItemTeamNameMuted)];
		
        if(![itemCell teamButtonDisabled])
            CGContextFillRect(context,CGRectMake(itemCell.teamNameRect.origin.x,
                                                 itemCell.teamNameRect.origin.y+kUnderlineYOffset,
                                                 itemCell.teamNameRect.size.width-1,
                                                 kUnderlineHeight));
		

		
		//----------------------------------	
		CGContextSetFillColorWithColor(context,subTextColor);
        
		[itemCell.itemCreatedAt drawInRect:itemCell.createdAtRect 
                                  withFont:kFontItemCreatedAt];
	}
    
    
    //----------------------------------
    if(![itemCell isHighlighted] || isTextOnly) {
        
        
        CGColorRef dataColor = isTextOnly && [itemCell isHighlighted] ? 
                                kColorTextHighlightedNoAttachment :
                                textColor;
        

        CGContextSetFillColorWithColor(context,dataColor);
        
        [itemCell.itemData drawInRect:itemCell.dataRect 
                             withFont:kFontItemData
                        lineBreakMode:UILineBreakModeWordWrap
                            alignment:UITextAlignmentLeft];
    }
    
    
    //----------------------------------
    if(![itemCell isHighlighted] || itemCell.isTouching) {
        
        CGContextSetFillColorWithColor(context,subTextColor);
        
        [itemCell.itemTouchesCountString drawInRect:itemCell.touchesCountRect
                                           withFont:kFontItemTouchesCount];
    }
	
	UIGraphicsPopContext();
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemFeedCell

@synthesize itemID					= _itemID;
@synthesize teamButtonPressed		= _teamButtonPressed;
@synthesize userButtonPressed		= _userButtonPressed;
@synthesize isTouching              = _isTouching;
@synthesize teamButtonDisabled      = _teamButtonDisabled;
@synthesize userButtonDisabled      = _userButtonDisabled;
@synthesize bylineMode              = _bylineMode;
@synthesize itemData				= _itemData;
@synthesize itemTeamName			= _itemTeamName;
@synthesize itemUserName			= _itemUserName;
@synthesize itemCreatedAt			= _itemCreatedAt;
@synthesize itemDetails				= _itemDetails;
@synthesize itemTouchesCountString  = _itemTouchesCountString;
@synthesize byline                  = _byline;
@synthesize highlightedAt			= _highlightedAt;
@synthesize userNameRect			= _userNameRect;
@synthesize atRect					= _atRect;
@synthesize teamNameRect			= _teamNameRect;
@synthesize dataRect				= _dataRect;
@synthesize touchesCountRect        = _touchesCountRect;
@synthesize createdAtRect           = _createdAtRect;
@synthesize bylineRect              = _bylineRect;
@synthesize delegate				= _delegate;
@synthesize attachmentType			= _attachmentType;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style
	reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
				reuseIdentifier:reuseIdentifier];
    
	if (self) {
        
        self.clipsToBounds                  = YES;
        self.contentView.clipsToBounds      = YES;
        self.contentView.backgroundColor    = [UIColor blackColor];
        
		CGRect frame = CGRectMake(0,0,320,320);
        
        
        UITapGestureRecognizer *singleTap   = [[[UITapGestureRecognizer alloc] initWithTarget:self 
                                                                                       action:@selector(handleTapGesture:)] autorelease];
        singleTap.numberOfTapsRequired      = 1;
        singleTap.delegate                  = self;
        [self addGestureRecognizer:singleTap];
        
        
        
		itemImageLayer					= [CALayer layer];
		itemImageLayer.frame			= frame;
		itemImageLayer.contentsScale	= [[UIScreen mainScreen] scale];
		itemImageLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSNull null], @"onOrderIn",
										   [NSNull null], @"onOrderOut",
										   [NSNull null], @"sublayers",
										   [NSNull null], @"contents",
										   nil];
		[[self.contentView layer] addSublayer:itemImageLayer];
		
        
		touchIconImageLayer					= [CALayer layer];
		touchIconImageLayer.frame			= CGRectMake(295,292,kTouchesIconWidth,kTouchesIconHeight);
		touchIconImageLayer.contentsScale	= [[UIScreen mainScreen] scale];
		touchIconImageLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
											   [NSNull null], @"onOrderIn",
											   [NSNull null], @"onOrderOut",
											   [NSNull null], @"sublayers",
											   [NSNull null], @"contents",
											   [NSNull null], @"bounds",
											   nil];
		[[self.contentView layer] addSublayer:touchIconImageLayer];
		
		
		
		playImageLayer					= [CALayer layer];
		playImageLayer.frame			= CGRectMake(282,kPlayIconY,kPlayIconWidth,kPlayIconHeight);
		playImageLayer.contentsScale	= [[UIScreen mainScreen] scale];
		playImageLayer.contents			= (id)[UIImage imageNamed:kImgPlay].CGImage;
		playImageLayer.hidden			= YES;
		playImageLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
										   [NSNull null], @"onOrderIn",
										   [NSNull null], @"onOrderOut",
										   [NSNull null], @"sublayers",
										   [NSNull null], @"contents",
										   [NSNull null], @"bounds",
										   nil];
		[[self.contentView layer] addSublayer:playImageLayer];
		
        
        /*
		shareImageLayer						= [CALayer layer];
		shareImageLayer.frame				= CGRectMake(280,283,24,19);
		shareImageLayer.contentsScale		= [[UIScreen mainScreen] scale];
		shareImageLayer.actions				= [NSMutableDictionary dictionaryWithObjectsAndKeys:
											   [NSNull null], @"contents",
											   nil];
		[[self.contentView layer] addSublayer:shareImageLayer];*/
        
        
		drawingLayer					= [DWItemFeedCellDrawingLayer layer];
		drawingLayer.itemCell			= self;
		drawingLayer.frame				= frame;
		drawingLayer.contentsScale		= [[UIScreen mainScreen] scale];
		drawingLayer.actions			= [NSMutableDictionary dictionaryWithObjectsAndKeys:
											[NSNull null], @"onOrderIn",
											[NSNull null], @"onOrderOut",
											[NSNull null], @"sublayers",
											[NSNull null], @"bounds",
											nil];
		[[self.contentView layer] addSublayer:drawingLayer];
		
		
		CALayer *separatorLayer			= [CALayer layer];
		separatorLayer.frame			= CGRectMake(0,319,320,1);
		separatorLayer.contentsScale	= [[UIScreen mainScreen] scale];
		separatorLayer.contents			= (id)[UIImage imageNamed:kImgSeparator].CGImage;
		[[self.contentView layer] addSublayer:separatorLayer];
		
		
		
		
		teamButton						= [[[UIButton alloc] init] autorelease];
        //teamButton.layer.opacity        = 0.2;
        //teamButton.backgroundColor		= [UIColor greenColor];
		
		[teamButton addTarget:self
						action:@selector(didTouchDownOnTeamButton:) 
				forControlEvents:UIControlEventTouchDown];
		
		[teamButton addTarget:self
						action:@selector(didTouchUpOnTeamButton:) 
			  forControlEvents:UIControlEventTouchUpInside];
		
		[teamButton addTarget:self
						action:@selector(didDragOutsideTeamButton:) 
			  forControlEvents:UIControlEventTouchDragOutside];
		
		[teamButton addTarget:self
						action:@selector(didDragInsideTeamButton:) 
			  forControlEvents:UIControlEventTouchDragInside];
		
		[self.contentView addSubview:teamButton];
		
		
		
		userButton						= [[[UIButton alloc] init] autorelease];
        //userButton.layer.opacity        = 0.2;
		//userButton.backgroundColor		= [UIColor redColor];
		
		[userButton addTarget:self
					   action:@selector(didTouchDownOnUserButton:)				
			 forControlEvents:UIControlEventTouchDown];
		
		[userButton addTarget:self
					   action:@selector(didTouchUpOnUserButton:) 
			 forControlEvents:UIControlEventTouchUpInside];
		
		[userButton addTarget:self
					   action:@selector(didDragOutsideUserButton:) 
			 forControlEvents:UIControlEventTouchDragOutside];
		
		[userButton addTarget:self
					   action:@selector(didDragInsideUserButton:) 
			 forControlEvents:UIControlEventTouchDragInside];
		
		[self.contentView addSubview:userButton];
		
		/*
		shareButton						= [[[UIButton alloc] init] autorelease];
		//shareButton.backgroundColor		= [UIColor greenColor];
		shareButton.frame				= CGRectMake(shareImageLayer.frame.origin.x - 25,
													 shareImageLayer.frame.origin.y - 15,
													 shareImageLayer.frame.size.width + 40,
													 shareImageLayer.frame.size.height + 30);
		
		[shareButton addTarget:self
					   action:@selector(didTouchUpOnShareButton:) 
			 forControlEvents:UIControlEventTouchUpInside];

		[self.contentView addSubview:shareButton];*/
		
        
        videoView           = [[[DWVideoView alloc] initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)] autorelease];
        videoView.delegate  = self;
        [self.contentView addSubview:videoView];
										   
		
		self.selectionStyle				= UITableViewCellSelectionStyleNone;
		self.accessoryType				= UITableViewCellAccessoryNone;
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	self.itemData               = nil;
	self.itemTeamName           = nil;
	self.itemUserName           = nil;
	self.itemCreatedAt          = nil;
	self.itemDetails            = nil;
	self.highlightedAt          = nil;
    self.byline                 = nil;
    self.itemTouchesCountString = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)resetItemNavigation {
    
    if(!_bylineMode) {
        
        CGSize userNameSize			= [self.itemUserName sizeWithFont:_userButtonDisabled ? kFontItemUserNameDisabled : kFontItemUserName];
        
        _userNameRect				= CGRectMake(kItemUserNameX,
                                                 kItemUserNameY,
                                                 userNameSize.width,
                                                 userNameSize.height);
        
        
        _atRect						= CGRectMake(_userNameRect.origin.x + _userNameRect.size.width + kAtXOffset,
                                                 kItemUserNameY,
                                                 kAtWidth,
                                                 kDefaultTextHeight);
        
        
        
        CGSize teamNameSize		= [self.itemTeamName sizeWithFont:_teamButtonDisabled ? kFontItemTeamNameDisabled : kFontItemTeamNameMuted
                                               constrainedToSize:CGSizeMake(kMaxTeamNameWidth-(_atRect.origin.x + _atRect.size.width),
                                                                            kDefaultTextHeight)
                                                   lineBreakMode:UILineBreakModeTailTruncation];
        
        _teamNameRect				= CGRectMake(_atRect.origin.x + _atRect.size.width + kTeamNameXOffset,
                                                 kItemUserNameY,
                                                 teamNameSize.width,
                                                 teamNameSize.height);
    }
    else {
        
        CGSize teamNameSize         = [self.itemTeamName sizeWithFont:kFontItemTeamName];
        
        _teamNameRect				= CGRectMake(kItemUserNameX,
                                                 kItemUserNameY,
                                                 teamNameSize.width,
                                                 teamNameSize.height);
        
        userButton.enabled          = NO;
        _userButtonDisabled         = YES;
        
        teamButton.frame			= CGRectMake(_teamNameRect.origin.x-4,
                                                 _teamNameRect.origin.y-11,
                                                 _teamNameRect.size.width+8,
                                                 _teamNameRect.size.height+27);
        
        CGSize bylineSize            = [self.byline sizeWithFont:kFontByline
                                               constrainedToSize:CGSizeMake(kMaxTeamNameWidth - kByLineXOffset - (_teamNameRect.origin.x+_teamNameRect.size.width), kDefaultTextHeight)
                                                   lineBreakMode:UILineBreakModeTailTruncation];
        
        _bylineRect                     = CGRectMake(_teamNameRect.origin.x + _teamNameRect.size.width + kByLineXOffset,
                                                     kBylineY,
                                                     bylineSize.width,
                                                     bylineSize.height);
         
    }
}

//----------------------------------------------------------------------------------------------------
- (void)resetItemDetailsPosition {
    
    self.itemTouchesCountString     = _itemTouchesCount ? [NSString stringWithFormat:@"%d",_itemTouchesCount] : @"";
    
    
    CGSize touchesCountSize         = [self.itemTouchesCountString sizeWithFont:kFontItemTouchesCount];
    
    _touchesCountRect               = CGRectMake(kDetailsX,
                                                 kDetailsY,
                                                 touchesCountSize.width,
                                                 touchesCountSize.height);
}

//----------------------------------------------------------------------------------------------------
- (void)resetTouchImageIconPosition {
    touchIconImageLayer.frame	= CGRectMake(_touchesCountRect.origin.x+_touchesCountRect.size.width+kTouchesIconXOffset,
											 kTouchesIconY,
											 touchIconImageLayer.frame.size.width, 
											 touchIconImageLayer.frame.size.height);
}

//----------------------------------------------------------------------------------------------------
- (void)resetCreatedAtPosition {
    CGSize createdAtSize            = [self.itemCreatedAt sizeWithFont:kFontItemCreatedAt];
    
    _createdAtRect                  = CGRectMake(touchIconImageLayer.frame.origin.x+touchIconImageLayer.frame.size.width,
                                                 kDetailsY,
                                                 createdAtSize.width,
                                                 createdAtSize.height);
}

/*
//----------------------------------------------------------------------------------------------------
- (void)resetPlayImageIconPosition {
    playImageLayer.frame		= CGRectMake(_createdAtRect.origin.x + _createdAtRect.size.width + kPlayIconXOffset,
                                             kPlayIconY,
                                             playImageLayer.frame.size.width,
                                             playImageLayer.frame.size.height);   
}*/

//----------------------------------------------------------------------------------------------------
- (void)reset {
	_highlighted				= NO;
    _isTouching                 = NO;
	_teamButtonPressed			= NO;
	_userButtonPressed			= NO;
    _teamButtonDisabled         = NO;
    _userButtonDisabled         = NO;
    _bylineMode                 = NO;
    
		
	[self resetItemNavigation];	
	
	
	CGSize dataSize				= [self.itemData sizeWithFont:kFontItemData
											constrainedToSize:CGSizeMake(kItemDataWidth,kItemDataHeight)
												lineBreakMode:UILineBreakModeWordWrap];
	
    if(dataSize.height <= kItemDataSubtitleHeightThreshold  && _attachmentType != kAttachmentNone) {
        _dataRect                   = CGRectMake(kItemDataX-kItemDataXSubTitleOffset,
                                                 320 - kItemDataYSubtitleOffset - dataSize.height,
                                                 dataSize.width,
                                                 dataSize.height);
    }
    else {
        _dataRect					= CGRectMake(kItemDataX,
                                                 kItemDataY + (kItemDataHeight - dataSize.height) / 2 - kItemDataYOffset,
                                                 dataSize.width,
                                                 dataSize.height);
    }
	
	
	
	[self resetItemDetailsPosition];

	 
	
	userButton.frame			= CGRectMake(_userNameRect.origin.x-4,
											 _userNameRect.origin.y-11,
											 _userNameRect.size.width+8,
											 _userNameRect.size.height+27);
    userButton.enabled          = YES;
	
	teamButton.frame			= CGRectMake(_teamNameRect.origin.x-4,
											 _teamNameRect.origin.y-11,
											 _teamNameRect.size.width+8,
											 _teamNameRect.size.height+27);
    teamButton.enabled         = YES;
	
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kNoAnimationDuration]
					 forKey:kCATransactionAnimationDuration];

	itemImageLayer.opacity			= _attachmentType == kAttachmentNone ? kNoAttachmentAlpha : kNormalAlpha;	
	itemImageLayer.backgroundColor	= _attachmentType == kAttachmentNone ? kColorNoAttachmentBg : kColorAttachmentBg;
	playImageLayer.hidden			= _attachmentType != kAttachmentVideo;
    
	/*
    shareButton.enabled             = YES;
    
	shareImageLayer.hidden			= NO;
	shareImageLayer.contents		= (id)[UIImage imageNamed:_attachmentType == kAttachmentNone ? kImgShare230 : kImgShare].CGImage;
    shareImageLayer.opacity         = _attachmentType == kAttachmentNone ? kOpacityImagesNoAttachment : kOpacityImagesWithAttachment;
    */
	
	touchIconImageLayer.hidden		= NO;
	touchIconImageLayer.contents	= (id)[UIImage imageNamed:_attachmentType == kAttachmentNone ? kImgTouchIcon230 : kImgTouchIcon].CGImage;
    touchIconImageLayer.opacity     = _attachmentType == kAttachmentNone ? kOpacityImagesNoAttachment : kOpacityImagesWithAttachment;
	
	[self resetTouchImageIconPosition];
    [self resetCreatedAtPosition];
    //[self resetPlayImageIconPosition];
    
	[CATransaction commit];
	
	[videoView stopPlayingVideo];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)shouldTouch {
    return [_delegate shouldTouchItemWithID:_itemID];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted 
			  animated:(BOOL)animated {
	/*
	if(highlighted && !_highlighted) {
        _highlighted = YES;
        
        [self performSelector:@selector(testTouch)
                   withObject:nil 
                   afterDelay:kTouchInterval];
	}
	else if(!highlighted && _highlighted) {
            _highlighted = _isTouching;
    }
     */
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isHighlighted {
    return _highlighted;
}

//----------------------------------------------------------------------------------------------------
- (void)setItemImage:(UIImage*)itemImage {
	itemImageLayer.contents = (id)itemImage.CGImage;
}

//----------------------------------------------------------------------------------------------------
- (void)setDetails:(NSInteger)touchesCount 
	  andCreatedAt:(NSString*)createdAt {
	
	_itemTouchesCount               = touchesCount;
    self.itemCreatedAt              = [NSString stringWithFormat:@"  |  %@",createdAt];
    
    /*
    if(_attachmentType != kAttachmentVideo)
        self.itemCreatedAt          = [NSString stringWithFormat:@"  |  %@",createdAt];
    else
        self.itemCreatedAt          = [NSString stringWithFormat:@"  |  %@",createdAt];*/
}

//----------------------------------------------------------------------------------------------------
- (void)setTeamButtonAsDisabled {
    _teamButtonDisabled    = YES;
    teamButton.enabled     = NO;
    
    [self resetItemNavigation];
    
    [self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)setupBylineMode:(NSString*)byline {
    _bylineMode     = YES;
    self.byline     = byline;
    
    [self resetItemNavigation];
    [self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)setUserButtonAsDisabled {
    _userButtonDisabled     = YES;
    userButton.enabled      = NO;
    
    [self resetItemNavigation];
    
    [self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[drawingLayer setNeedsDisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)touchCell {
	_itemTouchesCount++;
    _isTouching = YES;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.5f] 
					 forKey:kCATransactionAnimationDuration];
	
    touchIconImageLayer.hidden = NO;
    [self resetItemDetailsPosition];
    [self resetTouchImageIconPosition];
    [self resetCreatedAtPosition];
    //[self resetPlayImageIconPosition];
    [self redisplay];
    	
	[CATransaction commit];
    
	[self performSelector:@selector(finishTouchCell) 
			   withObject:nil
			   afterDelay:1.0];
}

//----------------------------------------------------------------------------------------------------
- (void)finishTouchCell {
    _isTouching = NO;
    
   // if(_attachmentType != kAttachmentNone) {
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithFloat:0.5f] 
                         forKey:kCATransactionAnimationDuration];
        
        [self redisplay];
        touchIconImageLayer.hidden = _highlighted;
        
        [CATransaction commit];	
   // }
}

//----------------------------------------------------------------------------------------------------
- (void)highlightCell {	
    
    BOOL isTextOnly     = _attachmentType == kAttachmentNone;
    BOOL shouldTouch    = [self shouldTouch];
    
    if(shouldTouch)
        _isTouching = YES;
    
    userButton.enabled      = NO;
    teamButton.enabled     = NO;
    //shareButton.enabled     = NO;
	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kCellAnimationDuration] 
					 forKey:kCATransactionAnimationDuration];
	
	touchIconImageLayer.hidden      = !_isTouching;
	itemImageLayer.opacity          = isTextOnly ? kNoAttachmentAlpha : kHighlightAlpha;
    itemImageLayer.backgroundColor  = isTextOnly ? kColorNoAttachmentHighlightBg : kColorAttachmentBg;
	
	if(_attachmentType == kAttachmentVideo)
		playImageLayer.hidden	= YES;
	
	//shareImageLayer.hidden		= YES;
	
	[self redisplay];

	[CATransaction commit];
    
    if(_attachmentType == kAttachmentVideo)
        [videoView startPlayingVideoAtURL:[_delegate getVideoAttachmentURLForItemID:_itemID]];
    
    if(shouldTouch) {
        [_delegate cellTouched:_itemID];
        [self touchCell];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)fadeCell {
    
    BOOL isTextOnly             = _attachmentType == kAttachmentNone;
    _highlighted				= NO;
    
        	
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:kCellAnimationDuration] 
					 forKey:kCATransactionAnimationDuration];
	
	touchIconImageLayer.hidden      = NO;
	itemImageLayer.opacity          = kNormalAlpha;
    itemImageLayer.opacity          = isTextOnly ? kNoAttachmentAlpha : kNormalAlpha;
    itemImageLayer.backgroundColor  = isTextOnly ? kColorNoAttachmentBg : kColorAttachmentBg;
	
	if(_attachmentType == kAttachmentVideo)
		playImageLayer.hidden	= NO;
	
	//shareImageLayer.hidden		= NO;
	
	[self redisplay];
	
	[CATransaction commit];
    
    userButton.enabled      = YES;
    teamButton.enabled     = !_teamButtonDisabled;
    //shareButton.enabled     = !_userButtonDisabled;
}

//----------------------------------------------------------------------------------------------------
- (void)highlightTeamButton {
	_teamButtonPressed = YES;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)fadeTeamButton {
	_teamButtonPressed = NO;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)fadeUserButton {
	_userButtonPressed = NO;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)highlightUserButton {
	_userButtonPressed = YES;
	[self redisplay];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIControlEventTouches

//----------------------------------------------------------------------------------------------------
- (void)didTouchDownOnTeamButton:(UIButton*)button {
	[self highlightTeamButton];
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchUpOnTeamButton:(UIButton*)button {
	
	[self performSelector:@selector(fadeTeamButton) 
			   withObject:nil
			   afterDelay:kSelectionDelay];
    
    [_delegate userSelectedForItemID:_itemID];
}

//----------------------------------------------------------------------------------------------------
- (void)didDragOutsideTeamButton:(UIButton*)button {
	[self fadeTeamButton];
}

//----------------------------------------------------------------------------------------------------
- (void)didDragInsideTeamButton:(UIButton*)button {
	[self highlightTeamButton];
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchDownOnUserButton:(UIButton*)button {
	[self highlightUserButton];
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchUpOnUserButton:(UIButton*)button {

	[self performSelector:@selector(fadeUserButton) 
			   withObject:nil
			   afterDelay:kSelectionDelay];
	
    [_delegate teamSelectedForItemID:_itemID];
}

//----------------------------------------------------------------------------------------------------
- (void)didDragOutsideUserButton:(UIButton*)button {
	[self fadeUserButton];
}

//----------------------------------------------------------------------------------------------------
- (void)didDragInsideUserButton:(UIButton*)button {
	[self highlightUserButton];
}

/*
//----------------------------------------------------------------------------------------------------
- (void)didTouchUpOnShareButton:(UIButton*)button {
	[_delegate shareSelectedForItemID:_itemID];
}*/


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWVideoViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)playbackFinished {
    [self fadeCell];
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIGestureRecognizerDelegate

//----------------------------------------------------------------------------------------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer 
       shouldReceiveTouch:(UITouch *)touch {
    
    return ![touch.view isKindOfClass:[UIButton class]];
}

//----------------------------------------------------------------------------------------------------
- (void)handleTapGesture:(UITapGestureRecognizer*)recognizer {    
    
    //CGPoint location             = [recognizer locationInView:self];
    
    _highlighted = !_highlighted;
    
    if(!_highlighted) {
        [videoView stopPlayingVideo];
        [self fadeCell];
    }
    else
        [self highlightCell];    
}

@end

