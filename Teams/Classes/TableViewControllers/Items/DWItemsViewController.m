//
//  DWItemsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemsViewController.h"
#import "DWItemsLogicController.h"
#import "DWItem.h"
#import "NSObject+Helpers.h"

static NSString* const kMsgActionSheetCancel        = @"Cancel";
static NSString* const kMsgActionSheetDelete		= @"Delete";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemsViewController

@synthesize itemsLogicController    = _itemsLogicController;
@synthesize shellViewController     = _shellViewController;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
        self.itemsLogicController    = [[[DWItemsLogicController alloc] init] autorelease];
        self.itemsLogicController.tableViewController = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {    
    self.itemsLogicController    = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     * Add gesture recognizers to catch swipes on table view cells
     */
    UISwipeGestureRecognizer *swipeRight    = [[[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(handleSwipeGesture:)] 
                                               autorelease];
    swipeRight.direction                    = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:swipeRight];
    
    
    UISwipeGestureRecognizer *swipeLeft     = [[[UISwipeGestureRecognizer alloc] initWithTarget:self 
                                                                                         action:@selector(handleSwipeGesture:)] 
                                               autorelease];
    swipeLeft.direction                     = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipeLeft];
}

//----------------------------------------------------------------------------------------------------
- (void)setItemsDelegate:(id<DWItemsLogicControllerDelegate,NSObject>)delegate {
    self.itemsLogicController.delegate = delegate;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString *)className {
    
    id delegate = nil;
    
    if([className isEqualToString:[[DWItem class] className]])
        delegate = self.itemsLogicController;
    else
        delegate = [super getDelegateForClassName:className];
    
    return delegate;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
-(void)handleSwipeGesture:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint swipeLocation           = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath    = [self.tableView indexPathForRowAtPoint:swipeLocation];
        
        DWItemsDataSource *dataSource   = (DWItemsDataSource*)[self getDataSource];
        DWItem *item                    = [dataSource getItemAtIndexPath:swipedIndexPath];
        
        if ([item.user isCurrentUser]) {
            
            UIActionSheet *actionSheet  = [[UIActionSheet alloc] initWithTitle:nil 
                                                                      delegate:self 
                                                             cancelButtonTitle:kMsgActionSheetCancel
                                                        destructiveButtonTitle:kMsgActionSheetDelete
                                                             otherButtonTitles:nil];
            
            actionSheet.tag             = item.databaseID;
            
            
            [actionSheet showInView:self.shellViewController.view];
            [actionSheet release];
        }
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIActionSheet Delegate

//----------------------------------------------------------------------------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {	
	
    if (actionSheet.tag && buttonIndex == 0) {
        DWItemsDataSource *dataSource   = (DWItemsDataSource*)[self getDataSource];
        [dataSource deleteItemWithDatabaseID:actionSheet.tag];
    }
}


@end
