//
//  DWTouchPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTouchPresenter.h"
#import "DWTouch.h"
#import "DWSlimCell.h"
#import "DWUsersHelper.h"
#import "DWTouchesHelper.h"
#import "DWApplicationHelper.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTouchPresenter


//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWTouch *touch      = object;
    DWSlimCell *cell    = base;
    
    if(!cell)
        cell = [[DWSlimCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:identifier];
    
    cell.boldText   = [DWUsersHelper displayName:touch.user];
    cell.plainText  = [DWTouchesHelper subtitleForTouch:touch];
    cell.extraText  = [DWApplicationHelper timeAgoInWordsForTimestamp:touch.createdAtTimestamp];
    
    [touch.user startSmallImageDownload];
    
    [cell setImage:touch.user.smallImage];
    
    
    [cell reset];
    [cell redisplay];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kSlimCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType {    
    
    DWTouch  *touch = object;
    
    if(resourceType != kResourceTypeSmallUserImage || resourceID != touch.user.databaseID)
        return;
    
    DWSlimCell *cell = base;
    
    if([resource isKindOfClass:[UIImage class]]) {
        [cell setImage:resource];
        [cell redisplay];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(userSelected:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    DWTouch *touch = object;
    
    [delegate performSelector:sel 
                   withObject:touch.user];
}



@end
