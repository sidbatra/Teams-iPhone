//
//  DWTeamPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamPresenter.h"
#import "DWTeam.h"
#import "DWAttachment.h"
#import "DWTeamFeedCell.h"
#import "DWFatCell.h"
#import "DWConstants.h"

static CGFloat const kTeamFeedCellHeight    = 92;
static CGFloat const kTeamFatCellHeight     = 275;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)teamFeedCellForObject:(id)object
                             withBaseCell:(id)base
                       withCellIdentifier:(NSString*)identifier 
                     andPresentationStyle:(NSInteger)style {
    
    DWTeam *team			= object;
    DWTeamFeedCell *cell	= base;
    
    if(!cell) 
        cell = [[DWTeamFeedCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:identifier];
    
    
    cell.teamName       = team.name;
    cell.teamDetails    = style == kTeamPresenterStyleEventBased ? team.eventText : team.byline;
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
+ (UITableViewCell*)fatCellForObject:(id)object
                        withBaseCell:(id)base
                  withCellIdentifier:(NSString*)identifier {
    
    DWTeam *team                = object;
    DWFatCell *cell             = base;
    
    if(!cell)
        cell = [[DWFatCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:identifier];
    
    
    [team startLargeImageDownload];
    
    [cell setImage:team.attachment.largeImage];
    [cell setFirstLine:team.name];
    [cell setSecondLine:team.byline];
        
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    UITableViewCell *cell = nil;
    
    if(style == kTeamPresenterStyleFat) {
        cell = [self fatCellForObject:object
                         withBaseCell:base
                   withCellIdentifier:identifier];
    }
    else {
        cell = [self teamFeedCellForObject:object
                              withBaseCell:base
                        withCellIdentifier:identifier 
                      andPresentationStyle:style];
    }
    
    return cell;
}


//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return style == kTeamPresenterStyleFat ? kTeamFatCellHeight : kTeamFeedCellHeight;
}


//----------------------------------------------------------------------------------------------------
+ (void)updateSlimCell:(id)base 
             withImage:(UIImage*)image {
    
    DWTeamFeedCell *cell = base;
    
    [cell setTeamImage:image];
    [cell redisplay];
}

//----------------------------------------------------------------------------------------------------
+ (void)updateFatCell:(id)base 
            withImage:(UIImage*)image {
    
    DWFatCell *cell = base;
    [cell setImage:image];
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType {
    
    DWTeam *team = object;
    
    if (resourceType == kResourceTypeLargeAttachmentImage && team.attachment && 
        team.attachment.databaseID == resourceID && style == kTeamPresenterStyleFat) {
        
        [self updateFatCell:base 
                  withImage:(UIImage*)resource];
    }
    
    else if (resourceType == kResourceTypeSliceAttachmentImage && 
             team.attachment && team.attachment.databaseID == resourceID && style != kTeamPresenterStyleFat) {
        
        [self updateSlimCell:base 
                   withImage:(UIImage*)resource];
    }
}


//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
    SEL sel = @selector(teamSelected:);
    
    if(![delegate respondsToSelector:sel])
        return;
    
    
    DWTeam *team = object;
    
    [delegate performSelector:sel
                   withObject:team];
}

@end
