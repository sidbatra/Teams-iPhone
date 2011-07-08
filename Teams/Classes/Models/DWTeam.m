//
//  DWTeam.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeam.h"
#import "DWAttachment.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeam

@synthesize name                = _name;
@synthesize byline              = _byline;
@synthesize followingsCount     = _followersCount;
@synthesize membersCount        = _membersCount;
@synthesize createdAtTimestamp  = _createdAtTimestamp;
@synthesize attachment          = _attachment;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)freeAttachment {
    [self.attachment destroy];
    self.attachment = nil;
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	
	NSLog(@"team released %d",self.databaseID);
	
	self.name			= nil;
    self.byline         = nil;
    
    [self freeAttachment];
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)team {
    [super update:team];

    NSString *name                  = [team objectForKey:kKeyName];
    NSString *byline                = [team objectForKey:kKeyByLine];
    NSString *timestamp             = [team objectForKey:kKeyTimestamp];
    NSString *followingsCount       = [team objectForKey:kKeyFollowingsCount];
    NSString *membershipsCount      = [team objectForKey:kKeyMembershipsCount];    
    NSDictionary *attachment        = [team objectForKey:kKeyAttachment];
     
    
    if(name && ![self.name isEqualToString:name])
        self.name = name;
    
    if(byline && ![self.byline isEqualToString:byline])
       self.byline = byline;
       
    if(timestamp)
        _createdAtTimestamp = [timestamp floatValue];
    
    if(followingsCount)
        _followersCount = [followingsCount integerValue];
    
    if(membershipsCount)
        _membersCount = [membershipsCount integerValue];
    
    if(attachment) {

        if(self.attachment) {
            
            if([[attachment objectForKey:kKeyID] integerValue] != self.attachment.databaseID) {
                [self freeAttachment];
                self.attachment = [DWAttachment create:attachment];
            }
        }
        else
            self.attachment = [DWAttachment create:attachment];
    }
    
}

//----------------------------------------------------------------------------------------------------
- (void)startImageDownload {
	if(self.attachment)
		[self.attachment startSliceDownload];
}

@end
