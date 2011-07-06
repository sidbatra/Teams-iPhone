//
//  DWItem.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWItem.h"
#import "DWMemoryPool.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWItem

@synthesize data				= _data;
@synthesize hashedID            = _hashedID;
@synthesize touchesCount		= _touchesCount;
@synthesize attachment			= _attachment;
@synthesize place				= _place;
@synthesize user				= _user;
@synthesize usesMemoryPool		= _usesMemoryPool;
@synthesize isTouched			= _isTouched;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
		_usesMemoryPool		= YES;
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
	
	//NSLog(@"item being removed - %d",_databaseID);
	
	self.data		= nil;
    self.hashedID   = nil;
    
    if(self.attachment) {
        
       // if(_usesMemoryPool)
       //     [[DWMemoryPool sharedDWMemoryPool]  removeObject:_attachment 
       //                                                atRow:kMPAttachmentsIndex];
        
        self.attachment = nil;
    }
	
	if(self.place) {
		
		//if(_usesMemoryPool)
		//	[[DWMemoryPool sharedDWMemoryPool]  removeObject:_place
        //                                              atRow:kMPPlacesIndex];
		
		self.place = nil;
	}
	
	if(self.user) {
		
		//if(_usesMemoryPool)
		//	[[DWMemoryPool sharedDWMemoryPool]  removeObject:_user 
        //                                               atRow:kMPUsersIndex];
		
		self.user = nil;
	}
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)touchesCountDelta:(NSInteger)delta {
	_touchesCount += delta;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)createdTimeAgoStamp {
	NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:_createdAtTimestamp];
    NSDate *todayDate	= [NSDate date];
    
    return [todayDate timeIntervalSinceDate:createdDate];    
}

//----------------------------------------------------------------------------------------------------
- (NSString*)createdTimeAgoInWords {
	
	NSDate *createdDate = [NSDate dateWithTimeIntervalSince1970:_createdAtTimestamp];
    NSDate *todayDate	= [NSDate date];
    NSInteger ti		= [todayDate timeIntervalSinceDate:createdDate];
    int diff;
    	
	if (ti < 60) {
        return (ti <= 1) ? @"1 second ago": [NSString stringWithFormat:@"%d seconds ago", ti];
        
    } 
	else if (ti < 3600) {
        diff = round(ti/60);
        return (diff == 1) ? @"1 minute ago" : [NSString stringWithFormat:@"%d minutes ago", diff];
        
    } 
	else if (ti < 86400) {
        diff = round(ti/3600);		
        return (diff == 1) ? @"1 hour ago" : [NSString stringWithFormat:@"%d hours ago", diff];
        
    } 
    else if (ti < 518400) {
        diff = round(ti/86400);        
        return (diff == 1) ? @"1 day ago" : [NSString stringWithFormat:@"%d days ago", diff];
        
    }
	else {
		NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[outputFormatter setDateFormat:@"d MMM"];
		
		NSString *outputString = [NSString stringWithString:[outputFormatter stringFromDate:createdDate]];		
		return outputString;
    }
}

//----------------------------------------------------------------------------------------------------
- (void)populate:(NSDictionary*)item {
    
	_databaseID				= [[item objectForKey:kKeyID] integerValue];
	_touchesCount			= [[item objectForKey:kKeyTouchesCount] integerValue];
	_isTouched				= ![[item objectForKey:kKeyTouchID] isKindOfClass:[NSNull class]];
	_createdAtTimestamp		= [[item objectForKey:kKeyCreatedAt] doubleValue];
    
    self.hashedID			= [item objectForKey:kKeyHashedID];
	self.data				= [item objectForKey:kKeyData];
    
	
	//self.place = (DWPlace*)[[DWMemoryPool sharedDWMemoryPool]  getOrSetObject:[item objectForKey:kKeyPlace] 
    //                                                                    atRow:kMPPlacesIndex];

	//self.user = (DWUser*)[[DWMemoryPool sharedDWMemoryPool]  getOrSetObject:[item objectForKey:kKeyUser]
    //                                                                  atRow:kMPUsersIndex];
    
    //if ([item objectForKey:kKeyAttachment])
    //    self.attachment = (DWAttachment*)[[DWMemoryPool sharedDWMemoryPool]  getOrSetObject:[item objectForKey:kKeyAttachment] 
    //                                                                                  atRow:kMPAttachmentsIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)item {
    		
    _touchesCount	= [[item objectForKey:kKeyTouchesCount] integerValue];
    _isTouched		= ![[item objectForKey:kKeyTouchID] isKindOfClass:[NSNull class]];
    
    
    [self.place update:[item objectForKey:kKeyPlace]];
    [self.user	update:[item objectForKey:kKeyUser]];
            
    if(self.attachment)
        [_attachment update:[item objectForKey:kKeyAttachment]];
}

//----------------------------------------------------------------------------------------------------
- (void)startRemoteImagesDownload {
	if (self.attachment)
		[self.attachment startPreviewDownload];
}

@end
