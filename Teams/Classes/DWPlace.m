//
//  DWPlace.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPlace.h"
#import "DWAttachment.h"
#import "DWRequestsManager.h"
#import "DWMemoryPool.h"
#import "UIImage+ImageProcessing.h"
#import "DWConstants.h"

static NSString* const kImgSmallPlaceHolder = @"place_small_placeholder.png";
static NSString* const kImgLargePlaceHolder = @"place_placeholder.png";
static NSString* const kMsgFindingLocality	= @"Finding locality";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPlace

@synthesize name				= _name;
@synthesize hashedID			= _hashedID;
@synthesize hasAddress          = _hasAddress;
@synthesize usesMemoryPool      = _usesMemoryPool;
@synthesize location			= _location;
@synthesize attachment			= _attachment;
@synthesize	town				= _town;
@synthesize state				= _state;
@synthesize country				= _country;

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        _usesMemoryPool = YES;
	}
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
}

//----------------------------------------------------------------------------------------------------
- (void)freeAttachment {
    
    
    if(self.attachment) {
        //[[DWMemoryPool sharedDWMemoryPool]  removeObject:self.attachment 
        //                                           atRow:kMPAttachmentSlicesIndex];
        
        self.attachment = nil;
    }
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	//NSLog(@"place released %d",_databaseID);
	
	self.name					= nil;
	self.hashedID				= nil;
	self.town					= nil;
	self.state					= nil;
	self.country				= nil;
	self.location				= nil;
    
    [self freeAttachment];
	
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)populateAttachment:(NSDictionary*)attachment {
   // self.attachment = (DWAttachment*)[[DWMemoryPool sharedDWMemoryPool]  getOrSetObject:attachment 
   //                                                                               atRow:kMPAttachmentSlicesIndex];
}

//----------------------------------------------------------------------------------------------------
- (void)populate:(NSDictionary*)place {		
	_databaseID				= [[place objectForKey:kKeyID] integerValue];
	
	self.name				= [place objectForKey:kKeyName];
	self.hashedID			= [place objectForKey:kKeyHashedID];
	_followersCount			= [[place objectForKey:kKeyFollowingsCount] integerValue];
	
    
    if([place objectForKey:kKeyLatitude])
        self.location = [[[CLLocation alloc] initWithLatitude:[[place objectForKey:kKeyLatitude]  floatValue] 
                                                    longitude:[[place objectForKey:kKeyLongitude] floatValue]] autorelease];
	
    
    [self updateAddress:[place objectForKey:kKeyAddress]];

    
	if([place objectForKey:kKeyAttachment])
        [self populateAttachment:[place objectForKey:kKeyAttachment]];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)place {

    if(!_usesMemoryPool) 
        _databaseID = [[place objectForKey:kKeyID] integerValue];
    
    
    NSString *newName = [place objectForKey:kKeyName];
     
     if(![self.name isEqualToString:newName])
         self.name = newName;
    
    NSString *newHashedID = [place objectForKey:kKeyHashedID];
    
    if(![self.hashedID isEqualToString:newHashedID])
        self.hashedID = newHashedID;
    
    if([place objectForKey:kKeyFollowingsCount])
        _followersCount	= [[place objectForKey:kKeyFollowingsCount] integerValue];
    
    if([place objectForKey:kKeyLatitude])
        self.location = [[[CLLocation alloc] initWithLatitude:[[place objectForKey:kKeyLatitude]  floatValue] 
                                                    longitude:[[place objectForKey:kKeyLongitude] floatValue]] autorelease];
    
    
    [self updateAddress:[place objectForKey:kKeyAddress]];
    
    
    if([place objectForKey:kKeyAttachment]) {
       
        NSDictionary *attachment = [place objectForKey:kKeyAttachment];
        
        if(self.attachment) {
            
            if([[attachment objectForKey:kKeyID] integerValue] != self.attachment.databaseID) {
                [self freeAttachment];
                [self populateAttachment:attachment];
            }
        }
        else
            [self populateAttachment:attachment];
    }
    
}

//----------------------------------------------------------------------------------------------------
- (void)updateAddress:(NSDictionary*)address {
    
    if(!_hasAddress && address) {
        _hasAddress		= YES;
        
        self.town		= [address objectForKey:kKeyShortTown];
        self.state		= [address objectForKey:kKeyShortState];
        self.country	= [address objectForKey:kKeyShortCountry];		
    }
    
}

//----------------------------------------------------------------------------------------------------
- (NSString*)fullAddress {
    NSString *address = [self displayAddressWithDefautMessage:NO];
    return [address length] ? [NSString stringWithFormat:@"%@ in %@",self.name,address] : self.name;
}

//----------------------------------------------------------------------------------------------------
- (NSString*)displayAddress {
    return [self displayAddressWithDefautMessage:YES];
}

//----------------------------------------------------------------------------------------------------
- (NSString*)displayAddressWithDefautMessage:(BOOL)addDefaultMessage {
    
	NSString *address = nil;
    
	if(_hasAddress) {
        NSMutableString *result     = [NSMutableString stringWithString:@""];
        NSInteger parts             = 0;
        
        if(self.town && [self.town length]) {
            [result appendString:self.town];
            parts++;
        }
        
        if(self.state && [self.state length]) {
            
            if(parts == 1)
                [result appendString:@", "];
            
            [result appendString:self.state];
            
            parts++;
        }
        
        if(parts < 2 && self.country && [self.country length]) {
            
            if(parts == 1)
                [result appendString:@", "];
            
            [result appendString:self.country];
        }
        
        address = [NSString stringWithString:result];
    }
	else
		address = addDefaultMessage ? kMsgFindingLocality : kEmptyString;
	
	return address;
}

//----------------------------------------------------------------------------------------------------
- (NSString*)mostSpecificAddressString {
    
    NSString *address = kEmptyString;
    
    if(!_hasAddress)
        return address;
    
    if(self.town && [self.town length])
        address = self.town;
    else if(self.state && [self.state length])
        address = self.state;
    else if(self.country && [self.country length])
        address = self.country;
    
    return address;
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)followersCount {
    return _followersCount;
}

//----------------------------------------------------------------------------------------------------
- (void)updateFollowerCount:(NSInteger)delta {
	_followersCount += delta;
}

//----------------------------------------------------------------------------------------------------
- (void)startPreviewDownload {
	if(self.attachment)
		[self.attachment startSliceDownload];
}

@end
