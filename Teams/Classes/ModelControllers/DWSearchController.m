//
//  DWSearchController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchController.h"
#import "DWRequestsManager.h"
#import "DWPoolObject.h"
#import "DWUser.h"
#import "DWTeam.h"
#import "NSString+Helpers.h"
#import "DWConstants.h"

static NSString* const kModelNamePrefix     = @"DW";
static NSString* const kSearchURI           = @"/search/%@.json?";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchController

@synthesize delegate  = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(searchLoaded:) 
													 name:kNSearchLoaded
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(searchLoadError:) 
													 name:kNSearchError
												   object:nil];
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Search controller released");
    
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Index

//----------------------------------------------------------------------------------------------------
- (void)getSearchResultsForQuery:(NSString*)query {
    
    NSString *localURL = [NSString stringWithFormat:kSearchURI,
                          [query stringByEncodingHTMLCharacters]];
    
    [[DWRequestsManager sharedDWRequestsManager] createDenwenRequest:localURL
                                                 successNotification:kNSearchLoaded
                                                   errorNotification:kNSearchError
                                                       requestMethod:kGet];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

//----------------------------------------------------------------------------------------------------
- (void)searchLoaded:(NSNotification*)notification {
    
    SEL searchSel     = @selector(searchLoaded:);
    
    if(![self.delegate respondsToSelector:searchSel])
        return;
    
    
    NSDictionary *info          = [notification userInfo];
    NSArray *data               = [info objectForKey:kKeyData];
    
    NSArray *objects            = [data objectAtIndex:0];
    NSArray *classes            = [data objectAtIndex:1];
    
    
    NSMutableArray  *results    = [NSMutableArray arrayWithCapacity:[objects count]];
    
    /**
     * Create DWPoolObject instances from the received results array
     */
    for(NSInteger i=0 ; i<[objects count] ; i++) {
        
        Class<DWPoolObjectProtocol> model   = NSClassFromString([NSString stringWithFormat:@"%@%@",
                                                                 kModelNamePrefix,
                                                                 [classes objectAtIndex:i]]);
        
        id object                           =  [model create:[objects objectAtIndex:i]];
        
        [results addObject:object];
    }
    
    [self.delegate performSelector:searchSel
                        withObject:results];
}

//----------------------------------------------------------------------------------------------------
- (void)searchLoadError:(NSNotification*)notification {
	
    SEL errorSel    = @selector(searchLoadError:);
    
    if(![self.delegate respondsToSelector:errorSel])
        return;
    
    
    NSError *error = [[notification userInfo] objectForKey:kKeyError];
    [self.delegate performSelector:errorSel 
                        withObject:[error localizedDescription]];
}


@end
