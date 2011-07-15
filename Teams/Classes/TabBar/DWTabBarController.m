//
//  DWTabBarController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTabBarController.h"
#import "DWCreateViewController.h"
#import "DWConstants.h"

#define kApplicationFrame	CGRectMake(0,20,320,460)
#define kFullScreenFrame	CGRectMake(0,0,320,460)
#define kResetFrameDelay    0.3

static NSString* const kImgTopShadow        = @"shadow_top.png";
static NSString* const kImgBottomShadow     = @"shadow_bottom.png";


/**
 * Declarations for private methods and properties
 */
@interface DWTabBarController()

/**
 * Image view with a shadow just below the navigation bar
 */
@property (nonatomic,retain) UIImageView *topShadowView;

/**
 * Image view with a shadow just above the tab bar
 */
@property (nonatomic,retain) UIImageView *bottomShadowView;

/**
 * Tab bar object for managing for the buttons and their states
 */
@property (nonatomic,retain) DWTabBar *tabBar;

/**
 * Controllers added to the tab bar 
 */
@property (nonatomic,retain) NSArray *subControllers;

/**
 * Adds the view for the tabBarControllers
 */
- (void)addViewAtIndex:(NSInteger)index;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTabBarController

@synthesize tabBar                  = _tabBar;
@synthesize topShadowView           = _topShadowView;
@synthesize bottomShadowView        = _bottomShadowView;
@synthesize subControllers          = _subControllers;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithTabBarFrame:(CGRect)tabBarFrame
            andTabBarInfo:(NSArray*)tabBarInfo {
	
	self = [super init];
	
	if(self) {
		
		self.tabBar                     = [[[DWTabBar alloc] initWithFrame:tabBarFrame
                                                                  withInfo:tabBarInfo] autorelease];
        self.tabBar.delegate            = self;
        
        self.topShadowView              = [[[UIImageView alloc] initWithImage:
                                            [UIImage imageNamed:kImgTopShadow]] autorelease];
        self.topShadowView.frame        = CGRectMake(0,44,320,5);
        
        self.bottomShadowView           = [[[UIImageView alloc] initWithImage:
                                            [UIImage imageNamed:kImgBottomShadow]] autorelease];
        self.bottomShadowView.frame     = CGRectMake(0,self.tabBar.frame.origin.y-5,320,5);
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.tabBar             = nil;
    self.topShadowView      = nil;
    self.bottomShadowView   = nil;
	self.subControllers     = nil;
    self.delegate           = nil;
	
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
	[self.view addSubview:self.topShadowView];
    [self.view addSubview:self.bottomShadowView];
	[self.view addSubview:self.tabBar];
    
	[self addViewAtIndex:self.tabBar.selectedIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)setupSubControllers:(NSArray*)controllers {
    self.subControllers = controllers;
}

//----------------------------------------------------------------------------------------------------
- (void)resetFrame {
	self.view.frame = kApplicationFrame;
}

//----------------------------------------------------------------------------------------------------
- (void)removeViewAtIndex:(NSInteger)index {
	[((UIViewController*)[self.subControllers objectAtIndex:index]).view removeFromSuperview];
}

//----------------------------------------------------------------------------------------------------
- (void)addViewAtIndex:(NSInteger)index {
	
	UIViewController *controller = [self.subControllers objectAtIndex:index];

	controller.view.frame = CGRectMake(0,0,
									   self.view.frame.size.width,
									   460-self.tabBar.frame.size.height);
	
	[self.view insertSubview:controller.view 
                belowSubview:self.topShadowView];
}

//----------------------------------------------------------------------------------------------------
- (UIViewController*)getSelectedController {
	return [self.subControllers objectAtIndex:self.tabBar.selectedIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)enableFullScreen {
	self.tabBar.hidden                      = YES;
    self.bottomShadowView.hidden            = YES;
    
    [self getSelectedController].view.frame = kFullScreenFrame;
}

//----------------------------------------------------------------------------------------------------
- (void)disableFullScreen {
	self.tabBar.hidden                      = NO;
    self.bottomShadowView.hidden            = NO;
    
    [self getSelectedController].view.frame = CGRectMake(0,0,
                                                         self.view.frame.size.width,
                                                         460-self.tabBar.frame.size.height);
}

//----------------------------------------------------------------------------------------------------
- (void)highlightTabAtIndex:(NSInteger)index {
    [self.tabBar highlightTabAtIndex:index];
}

//----------------------------------------------------------------------------------------------------
- (void)dimTabAtIndex:(NSInteger)index {
    [self.tabBar dimTabAtIndex:index];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTabBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedTabWithSpecialTab:(BOOL)isSpecial
					 modifiedFrom:(NSInteger)oldSelectedIndex 
							   to:(NSInteger)newSelectedIndex 
                    withResetType:(NSInteger)resetType {
	
	if(!isSpecial) {
		[self removeViewAtIndex:oldSelectedIndex];
		[self addViewAtIndex:newSelectedIndex];
	}
    
    if(resetType == kResetSoft) {
        [(UINavigationController*)[self getSelectedController] popToRootViewControllerAnimated:YES];
    }
    else if(resetType == kResetHard) {
        UINavigationController *selectedController = (UINavigationController*)[self getSelectedController];
        [selectedController popToRootViewControllerAnimated:NO]; 
       
        if([[selectedController topViewController] respondsToSelector:@selector(scrollToTop)])
            [[selectedController topViewController] performSelector:@selector(scrollToTop)];
    }
	
	[_delegate selectedTabModifiedFrom:oldSelectedIndex
									to:newSelectedIndex];
    
    if(!isSpecial)
        [[NSNotificationCenter defaultCenter] postNotificationName:kNTabSelectionChanged
															object:nil
														  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
																	[NSNumber numberWithInt:oldSelectedIndex],kKeyOldSelectedIndex,
																	[NSNumber numberWithInt:newSelectedIndex],kKeySelectedIndex,
																	nil]];
}


@end
