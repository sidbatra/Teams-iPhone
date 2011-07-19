//
//  DWUserPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserPresenter.h"
#import "DWUser.h"
#import "DWSlimCell.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 60;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWUserPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWUser *user        = object;
    DWSlimCell *cell	= base;
    
    if(!cell) 
        cell = [[[DWSlimCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                  reuseIdentifier:identifier] autorelease];
    
    
    cell.boldText   = user.firstName;
    cell.plainText  = user.byline;
    
    [user startSmallImageDownload];
    
    [cell setImage:user.smallImage];
    
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
    
    DWUser *user = object;
    
    if(resourceType == kResourceTypeSmallUserImage && user.databaseID == resourceID) {
        
        DWSlimCell *cell = base;
        
        [cell setImage:(UIImage*)resource];
        [cell redisplay];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withDelegate:(id)delegate {
    
    SEL sel = @selector(userSelected:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    DWUser *user = object;
    
    [delegate performSelector:sel
                   withObject:user];
}


@end
