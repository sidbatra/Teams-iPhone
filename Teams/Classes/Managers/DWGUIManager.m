//
//  DWGUIManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWGUIManager.h"
#import "DWNavBarBackButton.h"
#import "DWConstants.h"

static NSString* const kImgBackButton               = @"button_back.png";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWGUIManager

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)customBackButton:(id)target {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSLog(@"DWGUIManager customBackButton deprecated. See navBarBackButtonForNavController");
    
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButton] 
                      forState:UIControlStateNormal];
	
    [button addTarget:target
               action:@selector(didTapBackButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
	
    [button setFrame:CGRectMake(0, 0, 55, 44)];
	
	return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarBackButtonForNavController:(UINavigationController*)navControler {
    
    DWNavBarBackButton *backButton  = [[DWNavBarBackButton alloc] 
                                        initWithFrame:CGRectMake(0,0,55,44)];
    
    backButton.navController        = navControler;
	
	return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)navBarButtonWithImageName:(NSString*)imageName
                                       target:(id)target
                                  andSelector:(SEL)sel {

    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];    
    
    [button setBackgroundImage:[UIImage imageNamed:imageName] 
                      forState:UIControlStateNormal];
    
	[button addTarget:target
               action:sel
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0,0,55,44)];
    
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

//----------------------------------------------------------------------------------------------------
+ (UILabel*)navBarTitleViewForText:(NSString*)text {
    
    UILabel *titleLabel            = [[UILabel alloc] initWithFrame:CGRectMake(10,4,180,18)];
    titleLabel.textColor           = [UIColor whiteColor];
    titleLabel.textAlignment       = UITextAlignmentCenter;
    titleLabel.backgroundColor     = [UIColor clearColor];
    titleLabel.font                = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:17];
    titleLabel.text                = text;
    
    return titleLabel;
}

//----------------------------------------------------------------------------------------------------
+ (UIImageView*)backgroundImageViewWithFrame:(CGRect)frame {
    
    UIImageView *backgroundImageView    = [[UIImageView alloc] initWithFrame:frame];
    backgroundImageView.image           = [UIImage imageNamed:kImgTableViewBackground];
    backgroundImageView.contentMode     = UIViewContentModeTop;
    
    return backgroundImageView;
}

@end

