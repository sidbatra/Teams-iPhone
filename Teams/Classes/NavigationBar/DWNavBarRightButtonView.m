//
//  DWNavBarRightButtonView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarRightButtonView.h"


@implementation DWNavBarRightButtonView

static NSString* const kImgDoneButton = @"button_blue.png";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame title:(NSString*)title andTarget:(id)target {
    self = [super initWithFrame:frame];
    
    if (self) {
        navBarRightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [navBarRightButton addTarget:target
                              action:@selector(didTapNavBarRightButton:event:) 
                    forControlEvents:UIControlEventTouchUpInside];
        
        [navBarRightButton setFrame:CGRectMake(0, 0, 60, 44)];
        
        [navBarRightButton setBackgroundImage:[UIImage imageNamed:kImgDoneButton]
                                     forState:UIControlStateNormal];
        
        [navBarRightButton setTitle:title 
                           forState:UIControlStateNormal];

        
        navBarRightButton.titleLabel.textColor  = [UIColor whiteColor];        
        navBarRightButton.titleLabel.font       = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                  size:13];
        
        [self addSubview:navBarRightButton];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}

@end
