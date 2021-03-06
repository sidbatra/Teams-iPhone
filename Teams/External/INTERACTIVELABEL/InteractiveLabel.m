//
//  InteractiveLabel.m
//  TwitterrificTouch
//
//  Created by Craig Hockenberry on 4/2/08.
//  Copyright 2008 The Iconfactory. All rights reserved.
//

#import "InteractiveLabel.h"

static NSString * const TRANSPARENT_BUTTON_BG_IMAGE_NAME = @"trans27.png";


@implementation InteractiveLabel

@synthesize label;


- (void)createButtonWithText:(NSString *)text withFrame:(CGRect)frame andUrlIndex:(NSInteger)urlIndex
{
	UIButton *button = nil;
	button = [UIButton buttonWithType:UIButtonTypeCustom]; // autoreleased
	[button setBackgroundImage:[UIImage imageNamed:TRANSPARENT_BUTTON_BG_IMAGE_NAME] forState:UIControlStateHighlighted];

	[button setFrame:frame];
	[button.titleLabel setFont:self.label.font];
	[button setTitle:text forState:UIControlStateNormal];
	[button setTitleColor:[UIColor colorWithRed:0.098 green:0.333 blue:0.559 alpha:1.0] forState:UIControlStateNormal];

	[[button layer] setCornerRadius:5.0f];
	[[button layer] setMasksToBounds:YES];
	
	[button addTarget:_eventTarget action:@selector(didTapUrl:event:) forControlEvents:UIControlEventTouchUpInside];
	button.tag = _tagSeed + urlIndex;
	[self addSubview:button];
}				


- (void)createButtonsWithText:(NSString *)text atPoint:(CGPoint)point
{
	UIFont *font = self.label.font;
	NSString *expression = [[NSString alloc] 
							initWithString:@"(((http|ftp|https)://){1}([a-zA-Z0-9_-]+)(\\.[a-zA-Z0-9_-]+)+([\\S,://\\.\\?=a-zA-Z0-9_-]*[^,)\\s]))"];
	
	NSString *match;
	NSEnumerator *enumerator = [text matchEnumeratorWithRegex:expression];
	while (match = [enumerator nextObject])
	{
		CGSize matchSize = [match sizeWithFont:font];

		NSRange matchRange = [text rangeOfString:match];
		NSRange measureRange = NSMakeRange(0, matchRange.location);
		NSString *measureText = [text substringWithRange:measureRange];
		CGSize measureSize = [measureText sizeWithFont:font];
			
		CGRect matchFrame = CGRectMake(measureSize.width - 3.0f, point.y, matchSize.width + 6.0f, matchSize.height);
		[self createButtonWithText:match withFrame:matchFrame andUrlIndex:_urlIndex];		
		_urlIndex++;
	}
	
	[expression release];
}


#define MIN_WHITESPACE_LOCATION 5

- (void)createButtons
{
	CGRect frame = self.frame;
	if (frame.size.width == 0.0f || frame.size.height == 0.0f)
	{
		return;
	}
	
	UIFont *font = self.label.font;
	NSString *text = self.label.text;
	NSUInteger textLength = [text length];

	// by default, the output starts at the top of the frame
	CGPoint outputPoint = CGPointZero;
	CGSize textSize = [text sizeWithFont:font constrainedToSize:frame.size];
	CGRect bounds = [self bounds];
	if (textSize.height < bounds.size.height)
	{
		// the lines of text are centered in the bounds, so adjust the output point
		CGFloat boundsMidY = CGRectGetMidY(bounds);
		CGFloat textMidY = textSize.height / 2.0;
		outputPoint.y = ceilf(boundsMidY - textMidY);
	}

	// initialize whitespace tracking
	BOOL scanningWhitespace = NO;
	NSRange whitespaceRange = NSMakeRange(NSNotFound, 0);
	
	// scan the text
	NSRange scanRange = NSMakeRange(0, 1);
	while (NSMaxRange(scanRange) < textLength)
	{
		NSRange tokenRange = NSMakeRange(NSMaxRange(scanRange) - 1, 1);
		NSString *token = [text substringWithRange:tokenRange];

#if 0
		// debug bytes in token
		char buffer[10];
		NSUInteger usedLength;
		[token getBytes:&buffer maxLength:10 usedLength:&usedLength encoding:NSUTF8StringEncoding options:0 range:NSMakeRange(0, [token length]) remainingRange:NULL];
		NSUInteger index;
		for (index = 0; index < usedLength; index++)
		{
			NSLog(@"token: %3d 0x%02x", tokenRange.location, buffer[index] & 0xff);
		}
#endif
		
		if ([token isEqualToString:@" "] || [token isEqualToString:@"?"] || [token isEqualToString:@"-"])
		{
			//NSLog(@"------ whitespace: token = '%@'", token);
			
			// handle whitespace
			if (! scanningWhitespace)
			{
				// start of whitespace
				whitespaceRange.location = tokenRange.location;
				whitespaceRange.length = 1;
			}
			else
			{
				// continuing whitespace
				whitespaceRange.length += 1;
			}

			scanningWhitespace = YES;
			
			// scan the next position
			scanRange.length += 1;
		}
		else
		{
			// end of whitespace
			scanningWhitespace = NO;

			NSString *scanText = [text substringWithRange:scanRange];
			CGSize currentSize = [scanText sizeWithFont:font];
			
			BOOL breakLine = NO;
			if ([token isEqualToString:@"\r"] || [token isEqualToString:@"\n"])
			{
				// carriage return or newline caused line to break
				//NSLog(@"------ scanText = '%@', token = '%@'", scanText, token);
				breakLine = YES;
			}
			BOOL breakWidth = NO;
			if (currentSize.width > frame.size.width)
			{
				// the width of the text in the frame caused the line to break
				//NSLog(@"------ scanText = '%@', currentSize = %@", scanText, NSStringFromCGSize(currentSize));
				breakWidth = YES;
			}
			
			if (breakLine || breakWidth)
			{
				// the line broke, compute the range of text we want to output
				NSRange outputRange;
				
				if (breakLine)
				{
					// output before the token that broke the line
					outputRange.location = scanRange.location;
					outputRange.length = tokenRange.location - scanRange.location;
				}
				else
				{
					if (whitespaceRange.location != NSNotFound && whitespaceRange.location > MIN_WHITESPACE_LOCATION)
					{
						// output before beginning of the last whitespace
						outputRange.location = scanRange.location;
						outputRange.length = whitespaceRange.location - scanRange.location;
					}
					else
					{
						// output before the token that cause width overflow
						outputRange.location = scanRange.location;
						outputRange.length = tokenRange.location - scanRange.location;
					}
				}
				
				// make the buttons in this line of text
				[self createButtonsWithText:[text substringWithRange:outputRange] atPoint:outputPoint];

				if (breakLine)
				{
					// start scanning after token that broke the line
					scanRange.location = NSMaxRange(tokenRange);
					scanRange.length = 1;
				}
				else
				{
					if (whitespaceRange.location != NSNotFound && whitespaceRange.location > MIN_WHITESPACE_LOCATION)
					{
						// start scanning at end of last whitespace
						scanRange.location = NSMaxRange(whitespaceRange);
						scanRange.length = 1;
					}
					else
					{
						// start scanning at token that cause width overflow
						scanRange.location = NSMaxRange(tokenRange) - 1;
						scanRange.length = 1;
					}
				}

				// reset whitespace
				whitespaceRange.location = NSNotFound;
				whitespaceRange.length = 0;
				
				// move output to next line
				outputPoint.y += currentSize.height;
			}
			else
			{
				// the line did not break, scan the next position
				scanRange.length += 1;
			}
		}
	}
	
	// output to end
	[self createButtonsWithText:[text substringFromIndex:scanRange.location] atPoint:outputPoint];;
}

- (void)removeButtons
{
	UIView *view;
	for (view in [self subviews])
	{
		if ([view isKindOfClass:[UIButton class]])
		{
			[view removeFromSuperview];
		}
	}
}


- (id)initWithFrame:(CGRect)frame withTarget:(id)target
{
    if (self = [super initWithFrame:frame])
	{	
		self.label = [[UILabel alloc] init];
		[self addSubview:self.label];		
		[self.label release];
		_eventTarget = target;
		_urlIndex = 0;
	}
    return self;
}


- (void)dealloc
{	
	[self removeButtons];	
	[super dealloc];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)customizeUIFromText:(NSString*)data andUpdateFrame:(CGRect)frame andSeed:(NSInteger)tagSeed;
{	
	_tagSeed = tagSeed;
	_urlIndex = 0;
	[self removeButtons];
	[self.label setFrame:frame];
	[self.label setText:data];
	[self.label sizeToFit];
	[self.label setBackgroundColor:[UIColor clearColor]];
	
	CGRect viewFrame = self.frame;
	viewFrame.size.width = self.label.frame.size.width;
	viewFrame.size.height = self.label.frame.size.height;
	self.frame = viewFrame;
	[self createButtons];
}


- (void)changeButtonBackgroundColor:(UIColor*)color {
	UIView *view;
	for (view in [self subviews]) {
		if ([view isKindOfClass:[UIButton class]]) {
			[(UIButton*)view setBackgroundColor:color];
		}
	}
	[self setNeedsLayout];
}

@end
