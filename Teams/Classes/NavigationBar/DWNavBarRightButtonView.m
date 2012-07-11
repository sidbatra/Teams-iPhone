//
//  DWNavBarRightButtonView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarRightButtonView.h"


@implementation DWNavBarRightButtonView

static NSString* const kImgButton           = @"button_blue.png";
static NSString* const kImgButtonActive     = @"button_blue_active.png";

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
        
        
        [navBarRightButton setBackgroundImage:[UIImage imageNamed:kImgButton]
                                     forState:UIControlStateNormal];
        
        [navBarRightButton setBackgroundImage:[UIImage imageNamed:kImgButtonActive]
                                     forState:UIControlStateHighlighted];        
        
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


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors
//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}

@end
