//
//  DWContactPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWContactPresenter.h"
#import "DWContact.h"
#import "DWDoubleLineCell.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 44;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWContactPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWContact *contact                  = object;
    DWDoubleLineCell *cell              = base;
    
    if(!cell)
        cell = [[DWDoubleLineCell alloc] initWithStyle:UITableViewStylePlain
                                               reuseIdentifier:identifier];
    
    [cell setFirstLine:contact.fullName];
    [cell setSecondLine:contact.email];
    
    if(style == kContactPresenterStyleSelected) {
        [cell turnOnDarkerState];
    }

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
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(contactClicked:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    [delegate performSelector:sel 
                   withObject:object];
}

@end

