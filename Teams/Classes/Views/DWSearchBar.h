//
//  DWSearchBar.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWSearchBarDelegate;

/**
 * Custom search bar - UITextField with a cancel button
 */
@interface DWSearchBar : UIView<UITextFieldDelegate> {
    UITextField     *searchTextField;
    
    id<DWSearchBarDelegate> _delegate;
}

/**
 * Delegate property
 */
@property (nonatomic,assign) id<DWSearchBarDelegate> delegate;


/**
 * Take the search bar into an active state
 */
- (void)becomeActive;

/**
 * Widthdraw the search bar from an active state
 */
- (void)resignActive;

@end


/**
 * Protocol for the delegates of DWSearchBar instances
 */
@protocol DWSearchBarDelegate

/**
 * Fired when a search is initiated
 */
- (void)searchWithQuery:(NSString*)query;

/**
 * Fired when searching is cancelled
 */
- (void)searchCancelled;

@end
