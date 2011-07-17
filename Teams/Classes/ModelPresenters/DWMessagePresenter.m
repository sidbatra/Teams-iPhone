//
//  DWMessagePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMessagePresenter.h"
#import "DWMessageCell.h"
#import "DWMessage.h"

static CGFloat const kCellHeight  = 60;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWMessagePresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWMessage *message          = object;
    DWMessageCell *cell         = base;
    
    if(!cell)
        cell = [[[DWMessageCell alloc] initWithStyle:UITableViewStylePlain 
                                        reuseIdentifier:identifier] autorelease];
    
    [cell setMessage:message.content];
    
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
                withDelegate:(id)delegate {
    
}

@end
