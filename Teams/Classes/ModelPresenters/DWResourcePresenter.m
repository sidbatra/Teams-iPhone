//
//  DWResourcePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWResourcePresenter.h"
#import "DWResource.h"
#import "DWSlimCell.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 60;



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
        cell = [[[DWSlimCell alloc] initWithStyle:UITableViewStylePlain 
                                  reuseIdentifier:identifier] autorelease];
    
    cell.boldText   = resource.text;
    
    [cell setImage:resource.image];
    
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
    
    DWResource *resourceObject      = object;
    
    if(resourceType != resourceObject.imageResourceType || resourceID != resourceObject.imageResourceID)
        return;
    
    DWSlimCell *cell                = base;
    
    if([resource isKindOfClass:[UIImage class]]) {
        [cell setImage:resource];
        [cell redisplay];
        
        resourceObject.image = resource;
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withDelegate:(id)delegate {
    
    SEL sel = @selector(resourceClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
        
    
    [delegate performSelector:sel 
                   withObject:object];
}

@end
