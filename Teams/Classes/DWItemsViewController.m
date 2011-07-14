//
//  DWItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsViewController.h"
#import "DWItem.h"
#import "DWTouchesController.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsViewController

@synthesize touchesController   = _touchesController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        
        self.touchesController  = [[[DWTouchesController alloc] init] autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(largeAttachmentLoaded:) 
													 name:kNImgLargeAttachmentLoaded
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.touchesController  = nil;
        
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
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)largeAttachmentLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
        
    [self provideResourceToVisibleCells:kResoureTypeLargeAttachmentImage
                               resource:resource
                             resourceID:resourceID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemFeedCellDelegate


//----------------------------------------------------------------------------------------------------
- (BOOL)shouldTouchItemWithID:(NSInteger)itemID {
	
    DWItem *item = [DWItem fetch:itemID];
    
    return !item.isTouched;
	//return YES;
    //!item.isTouched && ![item.user isCurrentUser];
}

//----------------------------------------------------------------------------------------------------
- (void)cellTouched:(NSInteger)itemID {
    
    DWItem *item    = [DWItem fetch:itemID];
    item.isTouched  = YES;
    
    [self.touchesController postWithItemID:item.databaseID];
}

//----------------------------------------------------------------------------------------------------
- (void)teamSelectedForItemID:(NSInteger)itemID {
    
	NSLog(@"team selected for item ID - %d",itemID);
	
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
