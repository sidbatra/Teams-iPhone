//
//  DWProfileImagePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWProfileImagePresenter.h"
#import "DWProfileImage.h"
#import "DWImageCell.h"
#import "DWConstants.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileImagePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWProfileImage *profileImage    = object;
    DWImageCell *cell               = base;
    
    if(!cell)
        cell = [[[DWImageCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:identifier] autorelease];
    
    [cell setImage:profileImage.image];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kImageCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType { 
    
    DWProfileImage *profileImage = object;
    
    if(resourceType != kResourceTypeLargeUserImage || resourceID != profileImage.imageID)
        return;
    
    DWImageCell *cell = base;
    [cell setImage:resource];
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
