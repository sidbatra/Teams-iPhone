//
//  DWUserPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWUserPresenter.h"
#import "DWUser.h"
#import "DWUsersHelper.h"
#import "DWSlimCell.h"
#import "DWConstants.h"



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
    
    
    if(style == KUserPresenterStyleFullSignature)
        cell.boldText   = [DWUsersHelper shortSignatureWithTeamName:user]; 
    else
        cell.boldText   = user.firstName;
    
    if (style == kUserPresenterStyleNavigationDisabled) 
        [cell disableCellInteraction];
        
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
    
    return kSlimCellHeight;
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
    else if(resourceType == kResourceTypeUser && user.databaseID == resourceID) {
        
        DWSlimCell *cell    = base;
        DWUser *newUser     = resource;
        
        if(style == KUserPresenterStyleFullSignature)
            cell.boldText   = [DWUsersHelper shortSignatureWithTeamName:newUser]; 
        else
            cell.boldText   = newUser.firstName;
        
        cell.plainText  = newUser.byline;
        
        [cell reset];
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
