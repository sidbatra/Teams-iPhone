//
//  DWTeamsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsContainerViewController.h"
#import "DWSegmentedController.h"
#import "DWConstants.h"

static NSInteger const kSegmentedPlacesViewWidth	= 320;
static NSInteger const kSegmentedPlacesViewHeight	= 44;
static NSString* const kImgSegmentedViewPopularOn	= @"popular_on.png";
static NSString* const kImgSegmentedViewPopularOff	= @"popular_off.png";
static NSString* const kImgSegmentedViewSearchOn	= @"search_on.png";
static NSString* const kImgSegmentedViewSearchOff	= @"search_off.png";
static NSString* const kImgSegmentedViewNearbyOn	= @"nearby_on.png";
static NSString* const kImgSegmentedViewNearbyOff	= @"nearby_off.png";
static NSString* const kMsgUnload					= @"Unload called on places container";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsContainerViewController

@synthesize segmentedController = _segmentedController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.segmentedController    = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.segmentedController) {

        NSArray *segmentsInfo	= [NSArray arrayWithObjects:
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:114]	,kKeyWidth,
                                    [NSNumber numberWithBool:YES]	,kKeyIsSelected,
                                    kImgSegmentedViewPopularOn		,kKeySelectedImageName,
                                    kImgSegmentedViewPopularOff     ,kKeyNormalImageName,
                                    nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:92]		,kKeyWidth,
                                    [NSNumber numberWithBool:NO]	,kKeyIsSelected,
                                    kImgSegmentedViewSearchOn		,kKeySelectedImageName,
                                    kImgSegmentedViewSearchOff		,kKeyNormalImageName,
                                    nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:114]	,kKeyWidth,
                                    [NSNumber numberWithBool:NO]	,kKeyIsSelected,
                                    kImgSegmentedViewNearbyOn		,kKeySelectedImageName,
                                    kImgSegmentedViewNearbyOff		,kKeyNormalImageName,
                                    nil],
                                   nil];
        
        self.segmentedController = [[[DWSegmentedController alloc] initWithFrame:CGRectMake(0,0,320,44)
                                                                 andSegmentsInfo:segmentsInfo] autorelease];
        self.segmentedController.parentForSubControllers   = self;
        
        UIViewController *a = [[[UIViewController alloc] init] autorelease];
        a.view.backgroundColor = [UIColor redColor];
        UIViewController *b = [[[UIViewController alloc] init] autorelease];
        b.view.backgroundColor = [UIColor greenColor];
        UIViewController *c = [[[UIViewController alloc] init] autorelease];
        c.view.backgroundColor = [UIColor blueColor];
        
        self.segmentedController.subControllers = [NSArray arrayWithObjects:a,b,c,nil];
    }
    
    [self.navigationController.navigationBar addSubview:self.segmentedController.view];
    
	self.navigationItem.titleView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@",kMsgUnload);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    self.segmentedController.view.hidden = viewController != self;
    
    [super navigationController:navigationController 
         willShowViewController:viewController 
                       animated:animated];
}



@end
