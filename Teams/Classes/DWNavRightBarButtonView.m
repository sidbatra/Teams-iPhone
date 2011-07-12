//
//  DWRightNavBarButtonView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavRightBarButtonView.h"


@implementation DWNavRightBarButtonView

static NSString* const kImgDoneButton = @"button_blue.png";

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame title:(NSString*)title andTarget:(id)target {
    self = [super initWithFrame:frame];
    
    if (self) {
        rightNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightNavBarButton addTarget:target
                              action:@selector(didTapDoneButton:event:) 
                    forControlEvents:UIControlEventTouchUpInside];
        
        [rightNavBarButton setFrame:CGRectMake(0, 0, 60, 44)];
        
        [rightNavBarButton setBackgroundImage:[UIImage imageNamed:kImgDoneButton] 
                              forState:UIControlStateNormal];
        
        [rightNavBarButton setTitle:title 
                           forState:UIControlStateNormal];

        
        rightNavBarButton.titleLabel.textColor  = [UIColor whiteColor];        
        rightNavBarButton.titleLabel.font       = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                  size:13];
        
        [self addSubview:rightNavBarButton];
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
