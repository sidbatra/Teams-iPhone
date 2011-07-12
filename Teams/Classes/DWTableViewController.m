//
//  DWTableViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewController.h"
#import "DWModelPresenter.h"
#import "DWTableViewDataSource.h"
#import "NSObject+Helpers.h"
#import "DWConstants.h"


static NSString* const kPresenterClassSuffix        = @"Presenter";
static NSString* const kMsgNetworkError             = @"No connection; pull to retry.";


/**
 * Private method and property declarations
 */
@interface DWTableViewController()

/**
 * Get the data source object for the table view controller
 */
- (DWTableViewDataSource*)getDataSource;

/**
 * Get an object of the presenter class for the given className
 */
- (Class)presenterClassForClassName:(NSString*)className;

/**
 * Get the presentation style for the given class name
 */
- (NSInteger)presentationStyleForClassName:(NSString*)className;

/**
 * Generate and return the identifier for the given class name
 */
- (NSString*)identifierForClassName:(NSString*)className;

@end


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewController

@synthesize modelPresentationStyle  = _modelPresentationStyle;
@synthesize refreshHeaderView       = _refreshHeaderView;

//----------------------------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    
    if (self) {
        self.modelPresentationStyle = [NSMutableDictionary dictionary];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    self.tableView                  = nil;
    
    self.modelPresentationStyle     = nil;
	self.refreshHeaderView          = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor          =  [UIColor colorWithRed:0.2588
                                                               green:0.2588 
                                                                blue:0.2627
                                                               alpha:1.0];
    
	self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;
    
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
																						  0.0f - self.tableView.bounds.size.height,
																						  self.view.frame.size.width,
																						  self.tableView.bounds.size.height)] autorelease];
	self.refreshHeaderView.delegate = self;
    
    
	[self.refreshHeaderView applyBackgroundImage:nil 
								   withFadeImage:nil
							 withBackgroundColor:[UIColor colorWithRed:0.1764
                                                                 green:0.1764 
                                                                  blue:0.1764
                                                                 alpha:1.0]];
    
	[self.tableView addSubview:self.refreshHeaderView];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.refreshHeaderView   = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return nil;
}

//----------------------------------------------------------------------------------------------------
- (Class)presenterClassForClassName:(NSString*)className {
    return NSClassFromString([NSString stringWithFormat:@"%@%@",className,kPresenterClassSuffix]);
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)presentationStyleForClassName:(NSString*)className {
    NSString *style = [self.modelPresentationStyle objectForKey:className];
    return style ? [style integerValue] : kDefaultStyle;
}

//----------------------------------------------------------------------------------------------------
- (NSString*)identifierForClassName:(NSString *)className {
    return className;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource

//----------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self getDataSource] getTotalSections];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self getDataSource] getTotalObjectsForSection:section];
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id object = [[self getDataSource] getObjectAtIndex:indexPath.row
                                                      forSection:indexPath.section];
    
    NSString *className = [[object class] className];

    Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
    
	return [modelPresenter heightForObject:object
                     withPresentationStyle:[self presentationStyleForClassName:className]];
}

//----------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [[self getDataSource] getObjectAtIndex:indexPath.row
                                            forSection:indexPath.section];
    
    NSString *className     = [[object class] className];
    NSString* identifier    = [self identifierForClassName:className];
    
    id cell                 = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
    
	return [modelPresenter cellForObject:object
                            withBaseCell:cell
                      withCellIdentifier:identifier
                    andPresentationStyle:[self presentationStyleForClassName:className]];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIScrollViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{		
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
    //if (!decelerate && _tableViewUsage == kTableViewAsData)
	//	[self loadImagesForOnscreenRows];
}

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	//if(_tableViewUsage == kTableViewAsData)
	//	[self loadImagesForOnscreenRows];
}



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate 

//----------------------------------------------------------------------------------------------------
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
}

//----------------------------------------------------------------------------------------------------
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return NO;//return _isReloading; 
}

//----------------------------------------------------------------------------------------------------
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return nil;
}

@end
