//
//  DWGUIManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWGUIManager.h"
#import "DWNavBarBackButton.h"

static NSString* const kImgBackButton                   = @"button_back.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGUIManager

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)customBackButton:(id)target {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButton] 
                      forState:UIControlStateNormal];
	
    [button addTarget:target
               action:@selector(didTapBackButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
	
    [button setFrame:CGRectMake(0, 0, 55, 44)];
	
	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarBackButtonForNavController:(UINavigationController*)navControler {
    
    DWNavBarBackButton *backButton  = [[[DWNavBarBackButton alloc] 
                                        initWithFrame:CGRectMake(0,0,55,44)] 
                                       autorelease];
    
    backButton.navController        = navControler;
	
	return [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

@end

