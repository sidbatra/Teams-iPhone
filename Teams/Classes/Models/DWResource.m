//
//  DWResource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWResource.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWResource

@synthesize image               = _image;
@synthesize text                = _text;
@synthesize imageResourceType   = _imageResourceType;
@synthesize imageResourceID     = _imageResourceID;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        _imageResourceType  = kResourceTypeEmpty;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    NSLog(@"resource released");
    
    self.image  = nil;
    self.text   = nil;
    
    [super dealloc];
}

@end