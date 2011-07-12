//
//  DWItemPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItemPresenter.h"
#import "DWItemFeedCell.h"
#import "DWItem.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 320;

//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItemPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
             andPresentationStyle:(NSInteger)style {
    
    DWItem *item			= object;
    DWItemFeedCell *cell	= base;
    
    if(!cell) 
        cell = [[[DWItemFeedCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:identifier] autorelease];
    
	
    //cell.delegate			= self;
    
    cell.itemID				= item.databaseID;
    cell.itemData			= item.data;
    cell.itemPlaceName		= item.team.name;
    cell.itemUserName		= item.user.firstName;
    
    
    //[item startImagesDownload];
    
    
    if (item.attachment) {
        [cell setItemImage:item.attachment.largeImage];
        
        if([item.attachment isVideo])
            cell.attachmentType = kAttachmentVideo;
        else if([item.attachment isImage])
            cell.attachmentType = kAttachmentImage;
    }
    else {
        [cell setItemImage:nil];
        
        cell.attachmentType = kAttachmentNone;
    }
    
    [cell setDetails:item.touchesCount 
        andCreatedAt:@"9 hours ago"];
    
    [cell reset];
    [cell redisplay];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kCellHeight;
}

@end
