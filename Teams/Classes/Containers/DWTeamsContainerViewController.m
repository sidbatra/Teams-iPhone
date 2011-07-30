//
//  DWTeamsContainerViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTeamsContainerViewController.h"
#import "DWPopularTeamsViewController.h"
#import "DWSearchViewController.h"
#import "DWGUIManager.h"
#import "DWConstants.h"

static NSString* const kImgInvite                   = @"button_invite.png";
static NSString* const kImgSearch                   = @"button_search.png";
static NSString* const kMsgUnload					= @"Unload called on teams container";
static NSString* const kSearchBarText				= @"Search teams and people";
static NSString* const kSearchBarBackgroundClass	= @"UISearchBarBackground";
static NSInteger const kMinimumQueryLength			= 1;

/**
 * Private method and property declarations
 */
@interface DWTeamsContainerViewController()

/**
 * View creation methods
 */
- (void)loadPopularTeamsViewController;
- (void)loadSearchViewController;
- (void)loadSideButtons;
- (void)loadSearchBar;
@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTeamsContainerViewController

@synthesize popularTeamsViewController  = _popularTeamsViewController;
@synthesize searchViewController        = _searchViewController;
@synthesize searchBar                   = _searchBar;

//----------------------------------------------------------------------------------------------------
- (void)awakeFromNib {
	[super awakeFromNib];
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.popularTeamsViewController = nil;
    self.searchViewController       = nil;
    self.searchBar                  = nil;
    
	[super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)loadPopularTeamsViewController {
    
    if(!self.popularTeamsViewController) {
        self.popularTeamsViewController = [[[DWPopularTeamsViewController alloc] init] autorelease];
        [self.popularTeamsViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.popularTeamsViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadSearchBar {
    
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
}

//----------------------------------------------------------------------------------------------------
- (void)loadSearchViewController {
    
    if(!self.searchViewController) {
        self.searchViewController = [[[DWSearchViewController alloc] init] autorelease];
        [self.searchViewController setUsersDelegate:self];
        [self.searchViewController setTeamsDelegate:self];
    }
    
    [self.view addSubview:self.searchViewController.view];
}

//----------------------------------------------------------------------------------------------------
- (void)loadSideButtons {
    
    self.navigationItem.rightBarButtonItem  = [DWGUIManager navBarButtonWithImageName:kImgSearch
                                                                               target:self
                                                                          andSelector:@selector(didTapSearchButton:)];
    
    self.navigationItem.leftBarButtonItem   = [DWGUIManager navBarButtonWithImageName:kImgInvite
                                                                               target:self
                                                                          andSelector:@selector(didTapInviteButton:)];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPopularTeamsViewController];
    [self loadSearchViewController];
    [self loadSideButtons];
    //[self loadSearchBar];
    
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
    
    self.searchViewController.view.hidden = NO;
}

//----------------------------------------------------------------------------------------------------
- (void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    
    [self.searchBar setShowsCancelButton:NO 
                                animated:YES];    
    
    [self.searchBar setText:kEmptyString];
    
    [self.searchBar resignFirstResponder];
    
    self.searchViewController.view.hidden = YES;
}

//----------------------------------------------------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar*)theSearchBar {
	
	if(theSearchBar.text.length >= kMinimumQueryLength) {
		
		[self.searchBar resignFirstResponder];
        [self.searchViewController search:theSearchBar.text];
        
        
        /**
         * Keep the cancel button enabled
         */
        for (UIView *view in self.searchBar.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                ((UIButton*)view).enabled = YES;
                break;
            }
        }
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
#pragma mark UITouchEvents

//----------------------------------------------------------------------------------------------------
- (void)didTapSearchButton:(UIButton*)button {  
    NSLog(@"Search");
}

//----------------------------------------------------------------------------------------------------
- (void)didTapInviteButton:(UIButton*)button {  
    NSLog(@"invite");
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
