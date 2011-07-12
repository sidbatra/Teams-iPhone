//
//  DWSplashScreenViewController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DWSplashScreenViewControllerDelegate;

/*
 * First screen for the signed out state with options to login/signup
 */
@interface DWSplashScreenViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView    *_scrollView;
    UIPageControl   *_pageControl;
    NSMutableArray  *_viewControllers;
    
    BOOL            _pageControlUsed;
    
    id<DWSplashScreenViewControllerDelegate>    _delegate;
}

/**
 * Mutable array for view controllers having the splash screen images
 */
@property (nonatomic, retain) NSMutableArray *viewControllers;

/**
 * IBOutlets
 */
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

/**
 * IBAction methods
 */
- (IBAction)loginButtonClicked:(id)sender;
- (IBAction)signupButtonClicked:(id)sender;
- (IBAction)changePage:(id)sender;

/*
 * Custom init with delegate
 */
- (id)initWithDelegate:(id)theDelegate;


@end


/**
 * Delegate protocol to receive updates events
 * during splashscreen lifecycle
 */
@protocol DWSplashScreenViewControllerDelegate

/*
 * Fired when the login button is clicked
 */
-(void)loginInitiated;

/*
 * Fired when the signup button is clicked
 */
-(void)signupInitiated;

@end