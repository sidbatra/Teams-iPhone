//
//  DWGUIManager.h
//  Denwen
//
//  Created by Deepak Rao on 1/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "DWConstants.h"

@interface DWGUIManager : NSObject {
	
}

// Screen orientation and size helpers
+ (CGSize)currentScreenSize:(UIInterfaceOrientation)toInterfaceOrientation;
+ (CGSize)currentScreenSize;
+ (UIInterfaceOrientation)getCurrentOrientation;

+ (UIBarButtonItem*)customBackButton:(id)target;
+ (UIBarButtonItem*)placeDetailsButton:(id)target;
+ (UIBarButtonItem*)cameraNavButton:(id)target;
+ (UILabel*)customTitleWithText:(NSString*)text;


//Spinner methods
+ (void)showSpinnerInNav:(id)target;
+ (void)hideSpinnnerInNav:(id)target;

@end
