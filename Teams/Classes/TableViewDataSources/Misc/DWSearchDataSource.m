//
//  DWSearchDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchDataSource.h"
#import "DWAnalyticsManager.h"
#import "DWTeam.h"
#import "DWResource.h"
#import "NSObject+Helpers.h"


static NSString* const kMsgNoResults    = @"No Teams or people found.";
static NSString* const kImgTeamIcon     = @"slice_button_people.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchDataSource

@synthesize searchController    = _searchController;
@synthesize query               = _query;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if(self) {
        self.searchController            = [[[DWSearchController alloc] init] autorelease];
        self.searchController.delegate   = self;
    }
    
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.searchController   = nil;
    self.query              = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (DWResource*)resourceForTeam:(DWTeam*)team {
    
    DWResource *resource    = [[[DWResource alloc] init] autorelease];
    resource.text           = team.name;
    resource.subText        = team.byline;
    resource.ownerID        = team.databaseID;
    resource.image          = [UIImage imageNamed:kImgTeamIcon];
    
    return resource;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Data requests

//----------------------------------------------------------------------------------------------------
- (void)loadDataForQuery:(NSString*)query {
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self.delegate
                                                             withActionName:kActionNameForLoad
                                                               andExtraInfo:[NSString stringWithFormat:@"query=%@",
                                                                             query]];
    
    self.query  = query;
    [self.searchController getSearchResultsForQuery:query];
}

//----------------------------------------------------------------------------------------------------
- (void)refreshInitiated {
    [self loadDataForQuery:self.query];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWSearchControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchLoaded:(NSMutableArray*)results {
    [self clean];
    self.objects = [NSMutableArray array];
    
    for(DWPoolObject *object in results) {
        if([[object className] isEqualToString:[DWTeam className]]) {
            
            DWResource *resource = [self resourceForTeam:(DWTeam*)object];
            [self.objects addObject:resource];
            
            [object destroy];
        }
        else {
            [self.objects addObject:object];
        }
    }
    
    if([self.objects count]) {
        [self.delegate reloadTableView];
    }
    else {
        [self.delegate displayError:kMsgNoResults 
                      withRefreshUI:NO];
    }
}

//----------------------------------------------------------------------------------------------------
- (void)searchLoadError:(NSString*)error {
    NSLog(@"Search error - %@",error);
    [self.delegate displayError:error];
}

@end




