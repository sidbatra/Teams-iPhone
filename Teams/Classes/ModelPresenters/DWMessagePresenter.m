//
//  DWMessagePresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWMessagePresenter.h"
#import "DWMessageCell.h"
#import "DWMessage.h"
#import "DWConstants.h"



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
    
    if(message.interactive)
        [cell enableInteractiveMode];
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kMessageCellHeight;
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
    
    SEL sel             = @selector(messageClicked:);
    DWMessage *message  = object;
    
    if(![delegate respondsToSelector:sel] || !message.interactive)
        return;

    
    [delegate performSelector:sel 
                   withObject:object];
    
}

@end
