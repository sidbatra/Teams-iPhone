//
//  DWNavBarFillerView.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWNavBarFillerView.h"

static NSString* const kImgFillerImageView = @"nav_bar_empty_block.png";


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWNavBarFillerView

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        fillerImageView           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgFillerImageView]];
        fillerImageView.frame     = frame;
        
        [self addSubview:fillerImageView];
        [fillerImageView release];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Nav Stack Selectors

//----------------------------------------------------------------------------------------------------
- (void)shouldBeRemovedFromNav {
    
}

@end
