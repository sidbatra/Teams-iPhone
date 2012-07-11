//
//  DWNavBarBackButton.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarBackButton.h"
#import "DWAnalyticsManager.h"


static NSString* const kImgBackButton                   = @"button_back.png";

/**
 * Private method and property declarations
 */
@interface DWNavBarBackButton()

/**
 * Creates the back button which occupies the entire view
 */
- (void)createButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavBarBackButton

@synthesize navController   = _navController;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createButton];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)createButton {
    UIButton *button    =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame        =  self.frame;
    
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButton] 
                      forState:UIControlStateNormal];
    
    [button addTarget:self 
               action:@selector(didTapButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIControlEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapButton:(id)sender 
               event:(id)event {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.navController.topViewController
                                                             withActionName:@"back"];
    
	[self.navController popViewControllerAnimated:YES];
}



@end
