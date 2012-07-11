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
                      andText:(NSString*)text 
              forSpinnerStyle:(NSInteger)spinnerStyle;

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
        
        [self createLabelWithOrigin:CGPointMake(origin.x + 25, origin.y) 
                            andText:text 
                    forSpinnerStyle:spinnerStyle];
        
    }
    return self;
}

//----------------------------------------------------------------------------------------------------

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
	
    spinner                         = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:spinnerStyle];
	spinner.frame                   = CGRectMake(origin.x,origin.y,kSpinnerSize,kSpinnerSize);
    [spinner startAnimating];
    
	[self addSubview:spinner];	
}

//----------------------------------------------------------------------------------------------------
- (void)createLabelWithOrigin:(CGPoint)origin andText:(NSString *)text forSpinnerStyle:(NSInteger)spinnerStyle {
    
    messageLabel                    = [[UILabel alloc] 
                                        initWithFrame:CGRectMake(origin.x,origin.y,270,20)];	
    
	messageLabel.backgroundColor	= [UIColor clearColor];
    
    
    if (spinnerStyle == UIActivityIndicatorViewStyleGray) {
        messageLabel.font           = [UIFont fontWithName:@"HelveticaNeue" size:15];	
        messageLabel.textColor		= [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    }
    else {
        messageLabel.font			= [UIFont fontWithName:@"HelveticaNeue" size:17];	
        messageLabel.textColor		= [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    }
        
	messageLabel.textAlignment		= UITextAlignmentLeft;
	messageLabel.text				= text;
    
	[self addSubview:messageLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)setMessageText:(NSString*)text {
    messageLabel.text = text;
}

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}


@end
