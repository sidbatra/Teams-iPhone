//
//  DWNavBarNotificationsView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarNotificationsView.h"

static NSString* const kImgBackground       = @"button_notifications";
static NSString* const kDefaultText         = @"0";
static CGFloat   const kDisabledOpacity     = 0.5;
static CGFloat   const kEnabledOpacity      = 0.98;

/**
 * Private method and property declarations
 */
@interface DWNavBarNotificationsView()

/**
 * Add the background button to the view
 */
- (void)createBackgroundButton;

/**
 * Add the unread count to the view
 */
- (void)createUnreadCountLabel;

@end

//----------------------------------------------------------------------------------------------------
@implementation DWNavBarNotificationsView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {       
        [self createBackgroundButton];
        [self createUnreadCountLabel];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackgroundButton {
    backgroundButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundButton.alpha          = kDisabledOpacity;
    backgroundButton.frame          = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    
    //[backgroundButton setBackgroundImage:[UIImage imageNamed:kImgBackground]
    //                            forState:UIControlStateNormal];
    
    [backgroundButton addTarget:self 
                         action:@selector(didTapBackgroundButton:event:) 
               forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:backgroundButton];
}

//----------------------------------------------------------------------------------------------------
- (void)createUnreadCountLabel {
    unreadCountLabel                        = [[[UILabel alloc] initWithFrame:CGRectMake(13,11,24,22)] autorelease];
    unreadCountLabel.userInteractionEnabled = NO;
    unreadCountLabel.alpha                  = kDisabledOpacity;
    unreadCountLabel.layer.cornerRadius     = 2.5;
    unreadCountLabel.text                   = kDefaultText;
    unreadCountLabel.textColor              = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    unreadCountLabel.textAlignment          = UITextAlignmentCenter;
    unreadCountLabel.font                   = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                              size:13];
    

    [self addSubview:unreadCountLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setUnreadCount:(NSInteger)unreadCount {
    unreadCountLabel.text   = [NSString stringWithFormat:@"%d",unreadCount];
    unreadCountLabel.alpha  = unreadCount ? kEnabledOpacity : kDisabledOpacity;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapBackgroundButton:(id)sender 
                         event:(id)event {
    
    [self.delegate notificationsButtonClicked];
}

@end
