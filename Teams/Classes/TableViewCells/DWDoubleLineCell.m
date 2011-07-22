//
//  DWDoubleLineCell.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWDoubleLineCell.h"

static NSString* const kImgCheckMarkIcon			= @"pointer_mini_gray_dark.png";
static NSString* const kImgSeparator                = @"hr_gray_create.png";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineSelectedView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
    if (self) {
        self.opaque				= YES;
		self.backgroundColor	= [UIColor grayColor];
    }
    
    return self;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineView

@synthesize firstLine		= _firstLine;
@synthesize secondLine      = _secondLine;
@synthesize isDarker        = _isDarker;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	
    if (self) {
        self.opaque				= YES;
		self.backgroundColor	= [UIColor colorWithRed:0.9294 green:0.9294 blue:0.9294 alpha:1.0];
        self.isDarker           = NO;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	self.firstLine		= nil;
	self.secondLine     = nil;
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect {
    
    if (self.isDarker) 
        [[UIColor whiteColor] set];
    else
        _highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];
	
	[self.firstLine drawInRect:CGRectMake(20, 4, 293, 18) 
					  withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]
				 lineBreakMode:UILineBreakModeTailTruncation
					 alignment:UITextAlignmentLeft];
	
	if(self.isDarker)
        [[UIColor whiteColor] set];
    else
        _highlighted ? [[UIColor whiteColor] set] : [[UIColor colorWithRed:0.4588 green:0.4588 blue:0.4588 alpha:1.0] set];
	
	[self.secondLine drawInRect:CGRectMake(20, 21, 293, 18) 
                       withFont:[UIFont fontWithName:@"HelveticaNeue" size:15] 
                  lineBreakMode:UILineBreakModeTailTruncation
                      alignment:UITextAlignmentLeft];
	
    if (self.isDarker) 
        [[UIImage imageNamed:kImgCheckMarkIcon] drawInRect:CGRectMake(280, 7, 8, 11)];
	
	[[UIImage imageNamed:kImgSeparator] drawInRect:CGRectMake(0, 43, 320, 1)];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	_highlighted = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[self setNeedsDisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)setHighlighted:(BOOL)highlighted {
	_highlighted = highlighted;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)removeHighlight:(id)sender {
	_highlighted = NO;
	[self redisplay];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)isHighlighted {
    return _highlighted;
}

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWDoubleLineCell

@synthesize doubleLineView = _doubleLineView;

//----------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) {
		
		CGRect frame = CGRectMake(0.0,0.0,self.contentView.bounds.size.width,self.contentView.bounds.size.height);
		
		self.doubleLineView = [[[DWDoubleLineView alloc] initWithFrame:frame] autorelease];
        self.doubleLineView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.doubleLineView.contentMode         = UIViewContentModeRedraw;
		
		[self.contentView addSubview:self.doubleLineView];
		
		self.selectedBackgroundView = [[[DWDoubleLineSelectedView alloc] initWithFrame:frame] autorelease];
		self.accessoryType			= UITableViewCellAccessoryNone;
		//self.selectionStyle         = UITableViewCellSelectionStyleNone;
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {	
	self.doubleLineView = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
	[self.doubleLineView reset];
}

//----------------------------------------------------------------------------------------------------
- (void)setFirstLine:(NSString*)firstLine {
	self.doubleLineView.firstLine = firstLine;
	[self.doubleLineView redisplay];
	
}

//----------------------------------------------------------------------------------------------------
- (void)setSecondLine:(NSString *)secondLine {
	self.doubleLineView.secondLine = secondLine;
	[self.doubleLineView redisplay];
}

//----------------------------------------------------------------------------------------------------
- (void)turnOnDarkerState {
    self.doubleLineView.backgroundColor = [UIColor blackColor];
    self.doubleLineView.isDarker        = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)redisplay {
	[self.doubleLineView redisplay];
}



@end


