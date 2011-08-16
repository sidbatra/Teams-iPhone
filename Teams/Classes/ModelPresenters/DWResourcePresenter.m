//
//  DWResourcePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWResourcePresenter.h"
#import "DWResource.h"
#import "DWSlimCell.h"
#import "DWImageCell.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWResourcePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)slimCellForObject:(id)object
                         withBaseCell:(id)base
                   withCellIdentifier:(NSString*)identifier {
    
    DWResource *resource        = object;
    DWSlimCell *cell            = base;

    if(!cell)
        cell = [[[DWSlimCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:identifier] autorelease];

    cell.boldText   = resource.text;
    cell.plainText  = resource.subText;

    [cell setImage:resource.image];

    [cell reset];
    [cell redisplay];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)fatCellForObject:(id)object
                        withBaseCell:(id)base
                  withCellIdentifier:(NSString*)identifier {
    
    DWResource *resource        = object;
    DWImageCell *cell           = base;
    
    if(!cell)
        cell = [[[DWImageCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:identifier] autorelease];
    
    [cell setImage:resource.image];
    [cell setByline:resource.text];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    UITableViewCell *cell = nil;
    
    if(style == kResourcePresenterStyleFat) {
        cell = [self fatCellForObject:object
                         withBaseCell:base
                   withCellIdentifier:identifier];
    }
    else {
        cell = [self slimCellForObject:object
                          withBaseCell:base
                    withCellIdentifier:identifier];
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return style == kResourcePresenterStyleFat ? kImageCellHeight : kSlimCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updateFatCell:(id)base 
             withImage:(UIImage*)image {
    
    DWImageCell *cell = base;
    [cell setImage:image];
}

//----------------------------------------------------------------------------------------------------
+ (void)updateSlimCell:(id)base
             withImage:(UIImage*)image
           forResource:(DWResource*)resourceObject {

    DWSlimCell *cell = base;

    [cell setImage:image];
    [cell redisplay];
        
    resourceObject.image = image;
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
    
    if(style == kResourcePresenterStyleFat) {
        [self updateFatCell:base
                  withImage:resource];
    }
    else {
        [self updateSlimCell:base
                   withImage:resource
                 forResource:resourceObject];
    }
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
