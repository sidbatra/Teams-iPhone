//
//  DWNavBarNotificationsView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarCountView.h"

static NSString* const kImgBackground       = @"button_notifications";
static NSString* const kDefaultText         = @"0";
static CGFloat   const kDisabledOpacity     = 0.5;

/**
 * Private method and property declarations
 */
@interface DWNavBarCountView()

/**
 * Add the background button to the view
 */
- (void)createBackgroundButton;

/**
 * Add the count label to the view
 */
- (void)createCountLabel;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavBarCountView

@synthesize delegate = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {       
        [self createBackgroundButton];
        [self createCountLabel];
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
- (void)createCountLabel {
    countLabel                        = [[[UILabel alloc] initWithFrame:CGRectMake(12,11,25,22)] autorelease];
    countLabel.userInteractionEnabled = NO;
    countLabel.alpha                  = kDisabledOpacity;
    countLabel.layer.cornerRadius     = 2.5;
    countLabel.text                   = kDefaultText;
    countLabel.textColor              = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    countLabel.backgroundColor        = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];    
    countLabel.textAlignment          = UITextAlignmentCenter;
    countLabel.font                   = [UIFont fontWithName:@"HelveticaNeue-Bold" 
                                                        size:13];
    

    [self addSubview:countLabel];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.delegate = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)setCount:(NSInteger)count {
    countLabel.text   = [NSString stringWithFormat:@"%d",count];
    
    if (count) {
        countLabel.textColor        = [UIColor whiteColor];        
        countLabel.backgroundColor  = [UIColor colorWithRed:0.8 green:0.0 blue:0.0 alpha:1.0];
        countLabel.alpha            = 1.0;
    }
    else {
        countLabel.textColor        = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];        
        countLabel.backgroundColor  = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
        countLabel.alpha            = kDisabledOpacity;
    }
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UI Events

//----------------------------------------------------------------------------------------------------
- (void)didTapBackgroundButton:(id)sender 
                         event:(id)event {
    
    [self.delegate countButtonClicked];
}

@end
