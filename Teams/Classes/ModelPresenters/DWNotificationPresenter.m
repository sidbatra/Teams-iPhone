//
//  DWNotificationPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNotificationPresenter.h"
#import "DWNotification.h"
#import "DWSlimCell.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 60;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNotificationPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWNotification *notification    = object;
    DWSlimCell *cell                = base;
    
    if(!cell)
        cell = [[[DWSlimCell alloc] initWithStyle:UITableViewStylePlain 
                                  reuseIdentifier:identifier] autorelease];
    
    cell.boldText   = notification.entityData;
    cell.plainText  = notification.eventData;
    
    [notification startImageDownload];
    
    [cell setImage:notification.image];
    
    
    [cell reset];
    [cell redisplay];
    
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
    
    DWNotification  *notification = object;
    
    if(resourceType != kResourceTypeSmallNotificationImage || resourceID != notification.databaseID)
        return;
    
    DWSlimCell *cell = base;
    
    if([resource isKindOfClass:[UIImage class]]) {
        [cell setImage:resource];
        [cell redisplay];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withDelegate:(id)delegate {
    
    SEL sel = @selector(notificationClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
}


@end
