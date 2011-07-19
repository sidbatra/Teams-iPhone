//
//  DWTeamsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsContainerViewController.h"
#import "DWPopularTeamsViewController.h"
#import "DWSearchViewController.h"
#import "DWConstants.h"

static NSString* const kMsgUnload					= @"Unload called on teams container";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsContainerViewController

@synthesize popularTeamsViewController  = _popularTeamsViewController;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.popularTeamsViewController = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
        
    if(!self.popularTeamsViewController) {
        self.popularTeamsViewController = [[[DWPopularTeamsViewController alloc] init] autorelease];
        [self.popularTeamsViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.popularTeamsViewController.view];

    
    //DWSearchViewController *searchController = [[[DWSearchViewController alloc] init] autorelease];
    //[searchController setUsersDelegate:self];
    //[searchController setTeamsDelegate:self];
        
	self.navigationItem.titleView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@",kMsgUnload);
}


@end
