//
//  DWNavTitleView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavTitleView.h"
#import "DWConstants.h"

static NSString* const kImgPassiveButton                    = @"loading_bar_fail.png";
static NSString* const kImgPassiveButtonHighlighted         = @"static_button_active.png";
static NSString* const kImgActiveButton                     = @"button_follow.png";
static NSString* const kImgActiveButtonHighlighted          = @"button_follow_active.png";


/**
 * Private method and property declarations
 */
@interface DWNavTitleView()

/**
 * Reset all combinations of all states. Called right before
 * entering a state to undo all previous states.
 */
- (void)reset;

/**
 * Called when the title view is pressed
 */
- (void)titleViewButtonTapped;

/**
 * Apply inactive background images to the underlay button
 */
- (void)applyUnderButtonPassiveImages;


/**
 * View creation methods
 */
- (void)createUnderlayButton;
- (void)createTitleLabel;
- (void)createSubtitleLabel;
- (void)createStandaloneTitleLabel;
- (void)createSpinner;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavTitleView


//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self createUnderlayButton];
        [self createTitleLabel];
        [self createSubtitleLabel];            
        [self createStandaloneTitleLabel];
        [self createSpinner];
        
        _delegate = delegate;
    }
    return self;
}


//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)createUnderlayButton {    
    underlayButton              = [UIButton buttonWithType:UIButtonTypeCustom];
    
    underlayButton.frame        = CGRectMake(0, 0, 200, 44);
    underlayButton.hidden       = YES;
    
    
    [self applyUnderButtonPassiveImages];
        
    [underlayButton addTarget:self 
                       action:@selector(didTouchDownOnButton:) 
             forControlEvents:UIControlEventTouchDown];
    
    [underlayButton addTarget:self
                       action:@selector(didTouchUpInsideButton:) 
             forControlEvents:UIControlEventTouchUpInside];
    
    [underlayButton addTarget:self
                       action:@selector(didOtherTouchesToButton:) 
             forControlEvents:UIControlEventTouchUpOutside];
    
    [underlayButton addTarget:self
                       action:@selector(didOtherTouchesToButton:) 
             forControlEvents:UIControlEventTouchDragOutside];
    
    /*[underlayButton addTarget:self
     action:@selector(didOtherTouchesToButton:)
     forControlEvents:UIControlEventTouchDragInside];*/
    
    [self addSubview:underlayButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createTitleLabel {
    titleLabel                              = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, 18)];
    
    titleLabel.userInteractionEnabled       = NO;
    titleLabel.hidden                       = YES;
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.lineBreakMode                = UILineBreakModeTailTruncation;
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:15];
    
    [self addSubview:titleLabel];
    [titleLabel release];
}

//----------------------------------------------------------------------------------------------------
- (void)createSubtitleLabel {
    subtitleLabel                           = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 180, 18)];
    
    subtitleLabel.userInteractionEnabled    = NO;
    subtitleLabel.hidden                    = YES;
    subtitleLabel.textColor                 = [UIColor colorWithRed:255
                                                              green:255
                                                               blue:255
                                                              alpha:0.5];
    
    subtitleLabel.textAlignment             = UITextAlignmentCenter;
    subtitleLabel.lineBreakMode             = UILineBreakModeTailTruncation;
    subtitleLabel.backgroundColor           = [UIColor clearColor];
    subtitleLabel.font                      = [UIFont fontWithName:@"HelveticaNeue" 
                                                              size:13];
    
    [self addSubview:subtitleLabel];
    [subtitleLabel release];
}

//----------------------------------------------------------------------------------------------------
- (void)createStandaloneTitleLabel {
    standaloneTitleLabel                                = [[UILabel alloc] 
                                                           initWithFrame:CGRectMake(10, 12, 180, 18)];
    
    standaloneTitleLabel.userInteractionEnabled         = NO;
    standaloneTitleLabel.hidden                         = YES;
    standaloneTitleLabel.textColor                      = [UIColor whiteColor];
    standaloneTitleLabel.textAlignment                  = UITextAlignmentCenter;
    standaloneTitleLabel.backgroundColor                = [UIColor clearColor];
    standaloneTitleLabel.font                           = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                                          size:17];
    
    [self addSubview:standaloneTitleLabel];
    [standaloneTitleLabel release];
}

//----------------------------------------------------------------------------------------------------
- (void)createSpinner {
	spinner			= [[UIActivityIndicatorView alloc] 
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	spinner.frame	= CGRectMake(90,12,20,20);
    spinner.hidden  = YES;    
	
	[self addSubview:spinner];	
    [spinner release];
}

//----------------------------------------------------------------------------------------------------
- (void)applyUnderButtonPassiveImages {
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgPassiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgPassiveButtonHighlighted]
                              forState:UIControlStateHighlighted];
}

//----------------------------------------------------------------------------------------------------
- (void)reset {
    underlayButton.hidden = YES;
    underlayButton.enabled  = NO;
    
    titleLabel.hidden               = YES;
    subtitleLabel.hidden            = YES;
    standaloneTitleLabel.hidden     = YES;
    
    spinner.hidden                  = YES;
    [spinner stopAnimating];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Title View States

//----------------------------------------------------------------------------------------------------
- (void)displayTitle:(NSString*)title {
    
    [self reset];
    
    standaloneTitleLabel.hidden     = NO;
    standaloneTitleLabel.text       = title;
}


//----------------------------------------------------------------------------------------------------
- (void)displayTitle:(NSString*)title 
         andSubTitle:(NSString*)subTitle {
    
    [self reset];
    
    titleLabel.hidden           = NO;
    titleLabel.text             = title;
    
    subtitleLabel.hidden        = NO;
    subtitleLabel.text          = subTitle;
}

//----------------------------------------------------------------------------------------------------
- (void)displayActiveButtonWithTitle:(NSString*)title 
                         andSubTitle:(NSString*)subTitle {
    
    [self reset];
    
    underlayButton.enabled      = YES;
    underlayButton.hidden       = NO;
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButton]
                              forState:UIControlStateNormal];
    
    [underlayButton setBackgroundImage:[UIImage imageNamed:kImgActiveButtonHighlighted]
                              forState:UIControlStateHighlighted];
    
    
    titleLabel.hidden           = NO;
    titleLabel.text             = title;
    
    subtitleLabel.hidden        = NO;
    subtitleLabel.text          = subTitle;
}

//----------------------------------------------------------------------------------------------------
- (void)displayPassiveButtonWithTitle:(NSString*)title 
                          andSubTitle:(NSString*)subTitle {

    [self reset];
    
    underlayButton.enabled      = YES;
    underlayButton.hidden       = NO;
    
    [self applyUnderButtonPassiveImages];  
    
    
    titleLabel.hidden           = NO;
    titleLabel.text             = title;
    
    subtitleLabel.hidden        = NO;
    subtitleLabel.text          = subTitle;
}

//----------------------------------------------------------------------------------------------------
- (void)displaySpinner {
    
    [self reset];
    
    underlayButton.hidden           = NO;
    
    spinner.hidden                  = NO;
    [spinner startAnimating];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Button Touch Events

//----------------------------------------------------------------------------------------------------
- (void)titleViewButtonTapped {
    [_delegate didTapTitleView];
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchDownOnButton:(UIButton*)button {
	subtitleLabel.textColor = [UIColor whiteColor]; 
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchUpInsideButton:(UIButton*)button {
    subtitleLabel.textColor = [UIColor colorWithRed:255
                                              green:255 
                                               blue:255 
                                              alpha:0.5];
    [self titleViewButtonTapped];
}

//----------------------------------------------------------------------------------------------------
- (void)didOtherTouchesToButton:(UIButton*)button {
    subtitleLabel.textColor = [UIColor colorWithRed:255 
                                              green:255 
                                               blue:255 
                                              alpha:0.5]; 
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}


@end
