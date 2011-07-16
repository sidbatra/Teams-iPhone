//
//  DWTeamsViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsViewController.h"
#import "DWTableViewController.h"
#import "DWConstants.h"
#import "DWTeam.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsViewController

@synthesize tableViewController     = _tableViewController;
@synthesize delegate                = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {        
                
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(sliceAttachmentLoaded:) 
													 name:kNImgSliceAttachmentFinalized
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.tableViewController    = nil;
    self.delegate               = nil;
    
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTeamPresenterDelegate (implemented via selectors)

//----------------------------------------------------------------------------------------------------
- (void)teamSelected:(DWTeam*)team {
    [self.delegate teamSelected:team];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)sliceAttachmentLoaded:(NSNotification*)notification {
	
	NSDictionary *info		= [notification userInfo];
	NSInteger resourceID	= [[info objectForKey:kKeyResourceID] integerValue];
    id resource             = [info objectForKey:kKeyImage];
    
    [self.tableViewController provideResourceToVisibleCells:kResoureTypeSliceAttachmentImage
                                                   resource:resource
                                                 resourceID:resourceID];
}


@end
