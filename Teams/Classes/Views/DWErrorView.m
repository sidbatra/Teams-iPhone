//
//  DWErrorView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWErrorView.h"


static NSInteger const kSpinnerSize     = 20;
static NSString* const kImgBackground	= @"main_bg.png";
static NSString* const kImgRefresh      = @"post_retry.png";
static NSString* const kMsgRefreshText  = @"Try again";


/**
 * Private method and property declarations
 */
@interface DWErrorView()

/**
 * Create and add the text label to the view
 */
- (void)createText;

/**
 * Create a textured background view using an image
 */
- (void)createBackground;

/**
 * Refresh icon
 */
- (void)createRefreshImage;

/**
 * Label to display refresh text
 */
- (void)createRefreshText;

/**
 * Create an invisible button to handle clicks anywhere
 * on the view
 */
- (void)createViewButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWErrorView

@synthesize delegate    = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //[self createBackground];
        [self createText];
        [self createRefreshImage];
        [self createRefreshText];
        [self createViewButton];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setErrorMessage:(NSString *)message {
    _messageLabel.text = message;
}

//----------------------------------------------------------------------------------------------------
- (void)createText {
    
    _messageLabel                   = [[[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                                 self.frame.size.height / 2 - 35,
                                                                                 self.frame.size.width,
                                                                                 20)] autorelease];	
	_messageLabel.backgroundColor	= [UIColor clearColor];
	_messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
	_messageLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
	_messageLabel.textAlignment		= UITextAlignmentCenter;
    
	[self addSubview:_messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {
	
	UIImageView *backgroundImageView    = [[[UIImageView alloc] initWithFrame:self.frame] autorelease];
	backgroundImageView.image			= [UIImage imageNamed:kImgBackground];
	backgroundImageView.contentMode		= UIViewContentModeScaleToFill;
	
	[self addSubview:backgroundImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshImage {
    UIImageView *refreshImageView       = [[[UIImageView alloc] initWithFrame:CGRectMake(112,
                                                                                         self.frame.size.height / 2 - 10,
                                                                                         13,
                                                                                         15)] autorelease];	
	refreshImageView.image              = [UIImage imageNamed:kImgRefresh];
	
	[self addSubview:refreshImageView];
}

//----------------------------------------------------------------------------------------------------
- (void)createRefreshText {
    UILabel *refreshLabel           = [[[UILabel alloc] initWithFrame:CGRectMake(8,
                                                                                 self.frame.size.height / 2 - 10,
                                                                                 self.frame.size.width,
                                                                                 20)] autorelease];	
	refreshLabel.backgroundColor	= [UIColor clearColor];
	refreshLabel.font				= [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];	
	refreshLabel.textColor			= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
	refreshLabel.textAlignment		= UITextAlignmentCenter;
    refreshLabel.text               = kMsgRefreshText;
    
	[self addSubview:refreshLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)createViewButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame     = self.frame;
    
    [button addTarget:self
               action:@selector(didTapViewButton:)
     forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:button];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapViewButton:(UIButton*)button {
    
    SEL sel = @selector(errorViewTouched);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    [self.delegate performSelector:sel];
}


@end
