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
@synthesize subText             = _subText;
@synthesize statText            = _statText;
@synthesize imageResourceType   = _imageResourceType;
@synthesize imageResourceID     = _imageResourceID;
@synthesize ownerID             = _ownerID;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        _imageResourceType  = kResourceTypeEmpty;
        self.subText        = kEmptyString;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    NSLog(@"resource released");
    
    self.image      = nil;
    self.text       = nil;
    self.subText    = nil;
    self.statText   = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)hasImage {
    return self.image != nil;
}

@end
