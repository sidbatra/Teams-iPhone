//
//  DWItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItem.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItem

@synthesize data				= _data;
@synthesize attachment			= _attachment;
@synthesize team				= _team;
@synthesize user				= _user;
@synthesize touchesCount		= _touchesCount;
@synthesize isTouched			= _isTouched;
@synthesize createdAtTimestamp  = _createdAtTimestamp;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	NSLog(@"item released - %d",self.databaseID);
	
	self.data = nil;
    
    [self.attachment destroy];
    self.attachment = nil;
    
    [self.team destroy];
    self.team = nil;
    
    [self.user destroy];
    self.user = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)item {
    [super update:item];
    		
    NSString *data              = [item objectForKey:kKeyData];
    NSString *touchesCount      = [item objectForKey:kKeyTouchesCount];
    NSString *isTouched         = [item objectForKey:kKeyTouchID];
    NSString *timestamp         = [item objectForKey:kKeyTimestamp];
    NSDictionary *attachment    = [item objectForKey:kKeyAttachment];
    NSDictionary *team          = [item objectForKey:kKeyTeam];
    NSDictionary *user          = [item objectForKey:kKeyUser];

    
    if(data && ![self.data isEqualToString:data])
        self.data = data;
    
    if(touchesCount)
        _touchesCount = [touchesCount integerValue];
    
    if(timestamp)
        _createdAtTimestamp = [timestamp integerValue];
    
    _isTouched = ![isTouched isKindOfClass:[NSNull class]];
    
    
    if(attachment) {
        if(self.attachment)
            [self.attachment update:attachment];
        else
            self.attachment = [DWAttachment create:attachment];
    }
    
    if(team) {
        if(self.team)
            [self.team update:team];
        else
            self.team = [DWTeam create:team];
    }
    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)startImagesDownload {
	if (self.attachment)
		[self.attachment startLargeDownload];
}

@end
