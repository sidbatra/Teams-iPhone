//
//  DWTeamsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsContainerViewController.h"
#import "DWPopularTeamsViewController.h"
#import "DWSearchViewController.h"
#import "DWConstants.h"

static NSString* const kMsgUnload					= @"Unload called on teams container";
static NSString* const kSearchBarText				= @"Search teams and people";
static NSString* const kSearchBarBackgroundClass	= @"UISearchBarBackground";
static NSInteger const kMinimumQueryLength			= 1;


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsContainerViewController

@synthesize popularTeamsViewController  = _popularTeamsViewController;
@synthesize searchBar                   = _searchBar;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.popularTeamsViewController = nil;
    self.searchBar                  = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
        
    if(!self.popularTeamsViewController) {
        self.popularTeamsViewController = [[[DWPopularTeamsViewController alloc] init] autorelease];
        [self.popularTeamsViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.popularTeamsViewController.view];

    
    if(!self.searchBar) {
        self.searchBar					= [[[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,0)] autorelease];
        self.searchBar.delegate			= self;
        self.searchBar.placeholder		= kSearchBarText;
        self.searchBar.tintColor        = [UIColor colorWithRed:0.1764 
                                                          green:0.1764
                                                           blue:0.1764
                                                          alpha:1.0];
        
        self.searchBar.backgroundColor	= [UIColor colorWithRed:0.1764 
                                                         green:0.1764
                                                          blue:0.1764
                                                         alpha:1.0];
        [self.searchBar sizeToFit];	
        
        
        for (UIView *subview in self.searchBar.subviews) {
            if ([subview isKindOfClass:NSClassFromString(kSearchBarBackgroundClass)]) {
                [subview removeFromSuperview];
                break;
            }
        }
    }
    
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    
    //DWSearchViewController *searchController = [[[DWSearchViewController alloc] init] autorelease];
    //[searchController setUsersDelegate:self];
    //[searchController setTeamsDelegate:self];
        
	self.navigationItem.titleView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    NSLog(@"%@",kMsgUnload);
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UISearchBarDelegate

//----------------------------------------------------------------------------------------------------
- (void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
    
    [self.searchBar setShowsCancelButton:YES 
                                animated:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    
    [self.searchBar setShowsCancelButton:NO 
                                animated:YES];    
    
    [self.searchBar setText:kEmptyString];
    
    [self.searchBar resignFirstResponder];
}

//----------------------------------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar {
	
	if(theSearchBar.text.length >= kMinimumQueryLength) {
		
		//[self.searchBar resignFirstResponder];
		
		//[self.searchDataSource loadDataForQuery:theSearchBar.text];
	}
	
}

//----------------------------------------------------------------------------------------------------
- (void)searchBar:(UISearchBar*)searchBar
	textDidChange:(NSString*)searchText {
	
	if([searchText isEqualToString:kEmptyString]) {
	}
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UINavigationControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)navigationController:(UINavigationController *)navigationController 
	  willShowViewController:(UIViewController *)viewController
					animated:(BOOL)animated {
    
    self.searchBar.hidden = viewController != self;
    
    [super navigationController:navigationController 
         willShowViewController:viewController 
                       animated:animated];
}
@end
