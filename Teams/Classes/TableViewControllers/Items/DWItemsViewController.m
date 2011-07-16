//
//  DWItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsViewController.h"
#import "DWTableViewController.h"
#import "DWTouchesController.h"
#import "DWItem.h"
#import "DWTeam.h"
#import "DWUser.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsViewController

@synthesize touchesController       = _touchesController;
@synthesize tableViewController     = _tableViewController;
@synthesize delegate                = _delegate;

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
    
    self.touchesController      = nil;
    self.tableViewController    = nil;
    self.delegate               = nil;
        
    [super dealloc];
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
        
    [self.tableViewController provideResourceToVisibleCells:kResoureTypeLargeAttachmentImage
                                                   resource:resource
                                                 resourceID:resourceID];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWItemFeedCellDelegate (Implemented via DWItemPresenter)

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
- (NSString*)getVideoAttachmentURLForItemID:(NSInteger)itemID {
	DWItem *item = [DWItem fetch:itemID];
    return item.attachment.actualURL;
}

//----------------------------------------------------------------------------------------------------
- (void)teamSelectedForItemID:(NSInteger)itemID {
    
    SEL sel = @selector(teamSelected:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
        
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item.team];
}

//----------------------------------------------------------------------------------------------------
- (void)userSelectedForItemID:(NSInteger)itemID {
	
    SEL sel = @selector(userSelected:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item.user];
}

//----------------------------------------------------------------------------------------------------
- (void)shareSelectedForItemID:(NSInteger)itemID {
    
    SEL sel = @selector(shareSelectedForItem:);
    
    if(![self.delegate respondsToSelector:sel])
        return;
    
    
    DWItem *item  = [DWItem fetch:itemID];
    
    [self.delegate performSelector:sel
                        withObject:item];
}

@end

