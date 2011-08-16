//
//  DWSearchDataSource.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWSearchDataSource.h"
#import "DWAnalyticsManager.h"
#import "DWTeam.h"
#import "DWResource.h"
#import "NSObject+Helpers.h"


static NSString* const kImgTeamIcon     = @"slice_button_people.png";
static NSString* const kImgInvite		= @"slice_button_addpeople.png";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWSearchDataSource

@synthesize searchController    = _searchController;
@synthesize invite              = _invite;
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
    self.invite             = nil;
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
#pragma mark Private Methods

//----------------------------------------------------------------------------------------------------
- (void)addInviteResource {
    
    if(!self.invite)
        self.invite                 = [[[DWResource alloc] init] autorelease];
    
    self.invite.text                = @"Team or person not here?";
    self.invite.subText             = @"Invite them";
    self.invite.image               = [UIImage imageNamed:kImgInvite];
    
    [self.objects addObject:self.invite];
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
    
    [self addInviteResource];
    
    [self.delegate reloadTableView];

}

//----------------------------------------------------------------------------------------------------
- (void)searchLoadError:(NSString*)error {
    NSLog(@"Search error - %@",error);
    [self.delegate displayError:error];
}

@end




