//
//  DWSegmentedController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSegmentedController.h"

/**
 * Private method and property declarations
 */
@interface DWSegmentedController()

/**
 * Remove the sub controller view at the given index from 
 * parent for sub controllers
 */
- (void)removeViewAtIndex:(NSInteger)index;

/**
 * Add the sub controller view at the given index to
 * parent for sub controllers
 */
- (void)addViewAtIndex:(NSInteger)index;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSegmentedController

@synthesize segmentedControl            = _segmentedControl;
@synthesize subControllers              = _subControllers;
@synthesize parentForSubControllers     = _parentForSubControllers;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)controllerFrame
    andSegmentsInfo:(NSArray*)segmentsInfo {
	
	self = [super init];
	
	if(self) {
        
        _controllerFrame                = controllerFrame;
        
        self.segmentedControl           = [[DWSegmentedControl alloc] initWithFrame:CGRectMake(0,0,
                                                                                                controllerFrame.size.width,
                                                                                                controllerFrame.size.height)
                                                                    withSegmentsInfo:segmentsInfo];
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.parentForSubControllers    = nil;
    
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = _controllerFrame;
    
    self.segmentedControl.delegate  = self;
    [self.view addSubview:self.segmentedControl];
    
    [self addViewAtIndex:self.segmentedControl.selectedIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

//----------------------------------------------------------------------------------------------------
- (void)removeViewAtIndex:(NSInteger)index {
	[((UIViewController*)[self.subControllers objectAtIndex:index]).view removeFromSuperview];
}

//----------------------------------------------------------------------------------------------------
- (void)addViewAtIndex:(NSInteger)index {
    
	UIViewController *controller = [self.subControllers objectAtIndex:index];
    
    controller.view.frame = CGRectMake(0,0,
									   self.parentForSubControllers.view.frame.size.width,
									   self.parentForSubControllers.view.frame.size.height);
	

    [self.parentForSubControllers.view addSubview:controller.view];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSegmentedControlDelegate

//----------------------------------------------------------------------------------------------------
- (void)selectedSegmentModifiedFrom:(NSInteger)oldSelectedIndex 
                                 to:(NSInteger)newSelectedIndex {
    
    [self removeViewAtIndex:oldSelectedIndex];    
    [self addViewAtIndex:newSelectedIndex];
}

@end

