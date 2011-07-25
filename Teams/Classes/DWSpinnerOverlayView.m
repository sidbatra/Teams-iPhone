//
//  DWSpinnerOverlayView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSpinnerOverlayView.h"

static NSInteger const kSpinnerSize = 20;


/**
 * Private method and property declarations
 */
@interface DWSpinnerOverlayView()

/**
 * Create and add the spinner to the view
 */
- (void)createSpinnerWithOrigin:(CGPoint)origin 
                       andStyle:(NSInteger)spinnerStyle;

/**
 * Create and add the text label to the view
 */
- (void)createLabelWithOrigin:(CGPoint)origin 
                      andText:(NSString*)text;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSpinnerOverlayView

//----------------------------------------------------------------------------------------------------
- (id)initWithSpinnerOrigin:(CGPoint)origin andMessageText:(NSString*)text {
    return [self initWithSpinnerOrigin:origin
                          spinnerStyle:UIActivityIndicatorViewStyleGray
                        andMessageText:text];

}

//----------------------------------------------------------------------------------------------------
- (id)initWithSpinnerOrigin:(CGPoint)origin 
               spinnerStyle:(NSInteger)spinnerStyle andMessageText:(NSString*)text {
    
    self = [super initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    if (self) {
        self.backgroundColor            = [UIColor clearColor];
        
        [self disable];
        [self createSpinnerWithOrigin:origin andStyle:spinnerStyle];
        
        [self createLabelWithOrigin:CGPointMake(origin.x + 30, origin.y)
                            andText:text];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)enable {
    self.userInteractionEnabled     = YES;
    self.hidden                     = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)disable {
    self.userInteractionEnabled     = NO;
    self.hidden                     = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)createSpinnerWithOrigin:(CGPoint)origin andStyle:(NSInteger)spinnerStyle {
	
    UIActivityIndicatorView *spinner	= [[[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:spinnerStyle] 
                                           autorelease];
    
	spinner.frame                       = CGRectMake(origin.x,origin.y,kSpinnerSize,kSpinnerSize);
    [spinner startAnimating];
    
	[self addSubview:spinner];	
}

//----------------------------------------------------------------------------------------------------
- (void)createLabelWithOrigin:(CGPoint)origin andText:(NSString *)text {
    
    UILabel *messageLabel			= [[[UILabel alloc] 
                                        initWithFrame:CGRectMake(origin.x,origin.y,200,20)] 
                                       autorelease];	
    
	messageLabel.backgroundColor	= [UIColor clearColor];
	messageLabel.font				= [UIFont fontWithName:@"HelveticaNeue" size:17];	
	messageLabel.textColor			= [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
	messageLabel.textAlignment		= UITextAlignmentLeft;
	messageLabel.text				= text;
    
	[self addSubview:messageLabel];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}


@end
