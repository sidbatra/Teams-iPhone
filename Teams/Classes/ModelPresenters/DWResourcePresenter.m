//
//  DWResourcePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWResourcePresenter.h"
#import "DWResource.h"
#import "DWSlimCell.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWResourcePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWResource *resource        = object;
    DWSlimCell *cell            = base;
    
    if(!cell)
        cell = [[DWSlimCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:identifier];
    
    cell.boldText   = resource.text;
    cell.plainText  = resource.subText;
    
    if ([resource hasImage]) 
        [cell setImage:resource.image];
    else
        cell.largeText = resource.statText;
    
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
    
    DWResource *resourceObject = object;
    
    if(resourceType != resourceObject.imageResourceType || resourceID != resourceObject.imageResourceID)
        return;
    
    DWSlimCell *cell = base;
    
    [cell setImage:resource];
    [cell redisplay];
    
    resourceObject.image = resource;
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(resourceClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
        
    
    [delegate performSelector:sel 
                   withObject:object];
}

@end
