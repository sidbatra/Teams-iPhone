//
//  DWSearchBar.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchBar.h"

/**
 * Private method and property declarations
 */
@interface DWSearchBar()

/**
 * White background image behind the text field
 */
- (void)createBackground;

/**
 * Text field for writing search queries
 */
- (void)createSearchField;

/**
 * Cancel button for wiping the search view
 */
- (void)createCancelButton;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchBar

//----------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)createBackground {
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,, <#CGFloat height#>)]
}

//----------------------------------------------------------------------------------------------------
- (void)createSearchField {
    
}

//----------------------------------------------------------------------------------------------------
- (void)createCancelButton {
    
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [super dealloc];
}

@end
