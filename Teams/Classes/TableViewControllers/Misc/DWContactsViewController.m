//
//  DWContactsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactsViewController.h"

#import "DWContactsDataSource.h"
#import "NSObject+Helpers.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactsViewController

@synthesize contactsDataSource        = _contactsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.contactsDataSource = [[[DWContactsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.contactsDataSource = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.contactsDataSource;
}


//----------------------------------------------------------------------------------------------------
- (void)loadContactsMatching:(NSString *)string {
    [self.contactsDataSource loadContactsMatching:string];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
    self.view.hidden = YES;
}

@end
