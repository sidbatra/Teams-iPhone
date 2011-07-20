//
//  DWRightNavBarButtonView.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * Custom done button view for the login/signup nav bar
 */
@interface DWNavRightBarButtonView : UIView {
    UIButton *rightNavBarButton;
}

/**
 * Custom init to specify title and target for button events
 */
- (id)initWithFrame:(CGRect)frame 
              title:(NSString*)title 
          andTarget:(id)target;

@end
