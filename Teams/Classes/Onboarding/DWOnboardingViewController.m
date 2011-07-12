//
//  DWOnboardingViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWOnboardingViewController.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWOnboardingViewController

@synthesize onboardingNavController = _onboardingNavController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    if (self) {
        
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.onboardingNavController    = nil;
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.onboardingNavController.view.frame = CGRectMake(0, -20, 320, 480);
    [self.view addSubview:self.onboardingNavController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
