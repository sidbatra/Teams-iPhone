//
//  DWProfileImage.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWProfileImage.h"


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWProfileImage

@synthesize image       = _image;
@synthesize imageID     = _imageID;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        //Custom initialization
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    
    NSLog(@"profile image released");
    
    self.image = nil;
    
    [super dealloc];
}

@end