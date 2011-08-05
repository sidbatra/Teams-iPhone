//
//  DWTeam.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeam.h"
#import "DWAttachment.h"
#import "DWConstants.h"

static NSString* const kDiskKeyID			= @"DWTeam_id";
static NSString* const kDiskKeyName			= @"DWTeam_name";
static NSString* const kDiskKeyByline       = @"DWTeam_byline";
static NSString* const kDiskKeyMembersCount = @"DWTeam_members_count";



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
- (id)initWithCoder:(NSCoder*)coder {
    self = [super init];
    
    if(self) {
        self.databaseID             = [[coder decodeObjectForKey:kDiskKeyID] integerValue];
        self.name                   = [coder decodeObjectForKey:kDiskKeyName];
        self.byline                 = [coder decodeObjectForKey:kDiskKeyByline];
        self.membersCount           = [[coder decodeObjectForKey:kDiskKeyMembersCount] integerValue];
    }
    
    if(self.databaseID)
        [self mount];
    else 
        self = nil;
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)encodeWithCoder:(NSCoder*)coder {
    
    [coder encodeObject:[NSNumber numberWithInt:self.databaseID]    	forKey:kDiskKeyID];
    [coder encodeObject:self.name                                       forKey:kDiskKeyName];
    [coder encodeObject:self.byline                                     forKey:kDiskKeyByline];    
    [coder encodeObject:[NSNumber numberWithInt:self.membersCount]      forKey:kDiskKeyMembersCount];    
}

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
        _createdAtTimestamp = [timestamp integerValue];
    
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

//----------------------------------------------------------------------------------------------------
- (void)startLargeImageDownload {
	if(self.attachment)
		[self.attachment startLargeDownload];
}

@end
