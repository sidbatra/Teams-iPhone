//
//  DWItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsViewController.h"
#import "DWItem.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsViewController

@synthesize itemsDataSource = _itemsDataSource;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.itemsDataSource = [[[DWItemsDataSource alloc] init] autorelease];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    self.itemsDataSource  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
	[super viewDidLoad];
    
	CGRect frame		= self.view.frame;
	frame.origin.y		= 0; 
	self.view.frame		= frame;
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];  
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return self.itemsDataSource;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemFeedCellDelegate


//----------------------------------------------------------------------------------------------------
- (BOOL)shouldTouchItemWithID:(NSInteger)itemID {
	//DWItem *item = [DWItem fetch:itemID];
	
	return YES;//!item.isTouched && ![item.user isCurrentUser];
}

//----------------------------------------------------------------------------------------------------
- (void)cellTouched:(NSInteger)itemID {
    
    NSLog(@"cel touched with item id - %d",itemID);
    /*
	DWItem *item = (DWItem*)[[DWMemoryPool sharedDWMemoryPool]  getObject:itemID
																	atRow:kMPItemsIndex];
	
	item.isTouched = YES;
	
	[[DWRequestsManager sharedDWRequestsManager] createTouch:itemID];
     */
}

//----------------------------------------------------------------------------------------------------
- (void)placeSelectedForItemID:(NSInteger)itemID {
    
	NSLog(@"place selected for item ID - %d",itemID);
	
	//[_delegate placeSelected:item.place];
}

//----------------------------------------------------------------------------------------------------
- (void)userSelectedForItemID:(NSInteger)itemID {
	
    NSLog(@"user selected for item ID - %d",itemID);
    
	//[_delegate userSelected:item.user];
}

//----------------------------------------------------------------------------------------------------
- (void)shareSelectedForItemID:(NSInteger)itemID {
    
    NSLog(@"share selected for item ID - %d",itemID);
    
	//[_delegate shareSelected:item];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)getVideoAttachmentURLForItemID:(NSInteger)itemID {
	DWItem *item = [DWItem fetch:itemID];
    return item.attachment.actualURL;
}


@end
