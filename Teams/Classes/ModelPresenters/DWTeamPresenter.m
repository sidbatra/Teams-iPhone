//
//  DWTeamPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamPresenter.h"
#import "DWTeam.h"
#import "DWAttachment.h"
#import "DWTeamFeedCell.h"
#import "DWConstants.h"

static CGFloat const kCellHeight  = 92;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWTeam *team			= object;
    DWTeamFeedCell *cell	= base;
    
    if(!cell) 
        cell = [[[DWTeamFeedCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                                   reuseIdentifier:identifier] autorelease];
    
	    
    cell.teamName       = team.name;
    cell.teamDetails    = team.byline;
    cell.hasAttachment  = team.attachment ? YES : NO;
    
    if (team.attachment && team.attachment.sliceImage)
        [cell setTeamImage:team.attachment.sliceImage];
    else{
        [cell setTeamImage:nil];
        [team startImageDownload];
    }	
    
    if(style == kTeamPresenterStyleNavigationDisabled) {
        [cell hideChevron];
        [cell disableAnimation];
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
    
    DWTeam *team = object;
    
    if(resourceType == kResoureTypeSliceAttachmentImage && team.attachment && team.attachment.databaseID == resourceID) {
        
        DWTeamFeedCell *cell = base;
        
        [cell setTeamImage:(UIImage*)resource];
        [cell redisplay];
    }
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withDelegate:(id)delegate {
    
    SEL sel = @selector(teamSelected:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    DWTeam *team = object;
    
    [delegate performSelector:sel
                   withObject:team];
}

@end
