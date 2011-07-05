//
//  DWGUIManager.m
//  Denwen
//
//  Created by Deepak Rao on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DWGUIManager.h"

static NSString* const kImgBackButton                   = @"button_back.png";
static NSString* const kImgBackButtonActive             = @"button_back.png";
static NSString* const kImgPlaceDetailsButton           = @"button_map.png";
static NSString* const kImgPlaceDetailsButtonActive     = @"button_map.png";
static NSString* const kImgCameraButton                 = @"button_camera.png";
static NSString* const kImgCameraButtonActive           = @"button_camera.png";

static float const SCREEN_WIDTH = 320.0;
static float const SCREEN_HEIGHT = 416.0;
static float const SCREEN_ROTATED_WIDTH = 480.0;
static float const SCREEN_ROTATED_HEIGHT = 256.0;


@implementation DWGUIManager


#pragma mark -
#pragma mark Screen size and orientation helpers


// Returns the current screen size based on the orientation of the device
//
+ (CGSize)currentScreenSize:(UIInterfaceOrientation)toInterfaceOrientation {
	CGSize size;
	
	if(toInterfaceOrientation == UIDeviceOrientationPortrait || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
		size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
	else
		size = CGSizeMake(SCREEN_ROTATED_WIDTH, SCREEN_ROTATED_HEIGHT);
	
	return size;
}


// Partial Function for currentScreensize
//
+ (CGSize)currentScreenSize {
	return [self currentScreenSize:[UIApplication sharedApplication].statusBarOrientation];
}


// Gets the current status bar orientation
//
+ (UIInterfaceOrientation)getCurrentOrientation {
	return [UIApplication sharedApplication].statusBarOrientation;
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)customBackButton:(id)target {
	UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:kImgBackButton] forState:UIControlStateNormal];
	 [button setBackgroundImage:[UIImage imageNamed:kImgBackButtonActive] forState:UIControlStateHighlighted];
	[button addTarget:target action:@selector(didTapBackButton:event:) 
		   forControlEvents:UIControlEventTouchUpInside];
	[button setFrame:CGRectMake(0, 0, 55, 44)];
	
	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

//----------------------------------------------------------------------------------------------------
+ (UILabel*)customTitleWithText:(NSString*)text {
    UILabel *titleLabel                     = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 180, 18)];
    titleLabel.textColor                    = [UIColor whiteColor];
    titleLabel.textAlignment                = UITextAlignmentCenter;
    titleLabel.backgroundColor              = [UIColor clearColor];
    titleLabel.font                         = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:17];
    titleLabel.text                         = text;
    
    return [titleLabel autorelease];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)placeDetailsButton:(id)target {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgPlaceDetailsButton] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgPlaceDetailsButtonActive] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target 
               action:@selector(didTapPlaceDetailsButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0, 0, 55, 44)];
	
	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

//----------------------------------------------------------------------------------------------------
+ (UIBarButtonItem*)cameraNavButton:(id)target {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgCameraButton] 
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:kImgCameraButtonActive] 
                      forState:UIControlStateHighlighted];
    
	[button addTarget:target 
               action:@selector(didTapCameraButton:event:) 
     forControlEvents:UIControlEventTouchUpInside];
    
	[button setFrame:CGRectMake(0, 0, 55, 44)];
	
	return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


#pragma mark -
#pragma mark Spinner


// Start animating the spinner while the content is loaded in the background
//
+ (void)showSpinnerInNav:(id)target {
	[target navigationItem].rightBarButtonItem = nil;
	CGRect frame = CGRectMake(0.0, 0.0, 18.0, 18.0);
	
	UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:frame];
	[loading startAnimating];
	[loading sizeToFit];
	
	UIBarButtonItem *spinner = [[UIBarButtonItem alloc] initWithCustomView:loading];
	[loading release];
	
	//Add the spinner to the nav bar
	[target navigationItem].rightBarButtonItem = spinner; 
	[spinner release];
}


// End the spinner animation and optionally replace with a refresh button
//
+ (void)hideSpinnnerInNav:(id)target {	
	[target navigationItem].rightBarButtonItem = nil;
}

@end

