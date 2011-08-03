//
//  DWItemPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemPresenter.h"
#import "DWItemFeedCell.h"
#import "DWItem.h"
#import "DWItemsHelper.h"
#import "DWConstants.h"

static CGFloat const kCellHeight            = 320;
static NSString* const kImgTextBackground   = @"bg_dark_gradient_square.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWItem *item			= object;
    DWItemFeedCell *cell	= base;
    
    if(!cell) 
        cell = [[[DWItemFeedCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:identifier] autorelease];
    
	
    cell.delegate			= delegate;
    
    cell.itemID				= item.databaseID;
    cell.itemData			= item.data;
    cell.itemTeamName		= item.user.firstName;
    cell.itemUserName		= item.team.name;
    
    
    [item startImagesDownload];
    
    
    if (item.attachment) {
        [cell setItemImage:item.attachment.largeImage];
        
        if([item.attachment isVideo])
            cell.attachmentType = kAttachmentVideo;
        else if([item.attachment isImage])
            cell.attachmentType = kAttachmentImage;
    }
    else {
        [cell setItemImage:[UIImage imageNamed:kImgTextBackground]];
        
        cell.attachmentType = kAttachmentNone;
    }
    
    [cell setDetails:item.touchesCount 
        andCreatedAt:[DWItemsHelper createdAgoInWordsForItem:item]];
    
    [cell reset];
    [cell redisplay];
    
    
    switch(style) {
        case kItemPresenterStyleUserItems:
            [cell setTeamButtonAsDisabled];
            break;
        case kItemPresenterStyleTeamItems:
            [cell setupBylineMode:item.user.byline];
            break;
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType {
    
    DWItem *item = object;

    if(resourceType == kResourceTypeLargeAttachmentImage && item.attachment && item.attachment.databaseID == resourceID) {
        
        DWItemFeedCell *cell	= base;
        
        [cell setItemImage:(UIImage*)resource];
        [cell redisplay];
    }
    else if(resourceType == kResourceTypeUser && item.user.databaseID == resourceID) {
        
        DWItemFeedCell *cell	= base;
        DWUser *user            = resource;
        
        cell.itemTeamName		= user.firstName;
        
        if(style == kItemPresenterStyleTeamItems)
            [cell setupBylineMode:user.byline];
        
        [cell resetItemNavigation];
        [cell redisplay];
    }

}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withDelegate:(id)delegate {
    
}

@end
