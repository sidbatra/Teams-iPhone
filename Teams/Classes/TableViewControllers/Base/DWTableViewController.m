//
//  DWTableViewController.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTableViewController.h"
#import "DWModelPresenter.h"
#import "DWLoadingView.h"
#import "DWErrorView.h"
#import "NSObject+Helpers.h"

static NSString* const kPresenterClassSuffix        = @"Presenter";
static NSString* const kMsgNetworkError             = @"No connection; pull to retry.";


/**
 * Private method and property declarations
 */
@interface DWTableViewController()

/**
 * Get a UIView which is displayed while the data is being loaded
 */
- (UIView*)getTableLoadingView;

/**
 * Get a UIView which is displayed when an error occurs
 */
- (UIView*)getTableErrorView;

/**
 * Get an object of the presenter class for the given className
 */
- (Class)presenterClassForClassName:(NSString*)className;

/**
 * Get the presentation style for the given class name
 */
- (NSInteger)presentationStyleForClassName:(NSString*)className;

/**
 * Generate and return the identifier for the given class name and style
 */
- (NSString*)identifierForClassName:(NSString*)className 
                          withStyle:(NSInteger)style;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTableViewController

@synthesize modelPresentationStyle  = _modelPresentationStyle;
@synthesize refreshHeaderView       = _refreshHeaderView;
@synthesize loadingView             = _loadingView;
@synthesize errorView               = _errorView;

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
    self.loadingView                = nil;
    self.errorView                  = nil;
    
    [super dealloc];
}

//----------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGRect frame		= self.view.frame;
	frame.origin.y		= 0; 
	self.view.frame		= frame;
    
    self.tableView.scrollEnabled = NO;

    self.tableView.backgroundColor          = [UIColor clearColor];
	self.tableView.separatorStyle           = UITableViewCellSeparatorStyleNone;

    
    self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
																						  0.0f - self.tableView.bounds.size.height,
																						  self.view.frame.size.width,
																						  self.tableView.bounds.size.height)] autorelease];
	self.refreshHeaderView.delegate = self;
    
	[self.refreshHeaderView applyBackgroundImage:nil
								   withFadeImage:nil
							 withBackgroundColor:[UIColor clearColor]];
     
	[self.tableView addSubview:self.refreshHeaderView];
    
    [self getDataSource].delegate   = self;
    
    
    if(!self.loadingView)
        self.loadingView = [self getTableLoadingView];
    
    [self.view addSubview:self.loadingView];
    
    
    if(!self.errorView) {
        self.errorView          = [self getTableErrorView];
        self.errorView.hidden   = YES;
    }
    
    [self.view addSubview:self.errorView];
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
- (void)scrollToTop {
    [self.tableView scrollRectToVisible:CGRectMake(0,0,1,1) 
                               animated:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)provideResourceToVisibleCells:(NSInteger)resourceType
                             resource:(id)resource
                           resourceID:(NSInteger)resourceID {
    
    if(![self isViewLoaded])
        return;
    
    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];

	for (NSIndexPath *indexPath in visiblePaths) {            
        
        id object = [[self getDataSource] objectAtIndex:indexPath.row
                                             forSection:indexPath.section];
        
        NSString *className     = [[object class] className];
        id cell                 = [self.tableView cellForRowAtIndexPath:indexPath];
        
        Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
        
        [modelPresenter updatePresentationForCell:cell
                                         ofObject:object
                            withPresentationStyle:[self presentationStyleForClassName:className]
                                  withNewResource:resource
                                 havingResourceID:resourceID
                                           ofType:resourceType];
    }
}

//----------------------------------------------------------------------------------------------------
- (DWTableViewDataSource*)getDataSource {
    return nil;
}

//----------------------------------------------------------------------------------------------------
- (void)disablePullToRefresh {
    self.refreshHeaderView = nil;
}

//----------------------------------------------------------------------------------------------------
- (void)disableScrolling {
    self.tableView.scrollEnabled    = NO;    
    self.tableView.bounces          = NO;
}

//----------------------------------------------------------------------------------------------------
- (UIView*)getTableLoadingView {
    return [[[DWLoadingView alloc] initWithFrame:self.tableView.frame] autorelease];
}

//----------------------------------------------------------------------------------------------------
- (UIView*)getTableErrorView {
    DWErrorView *errorView  = [[[DWErrorView alloc] initWithFrame:self.tableView.frame] autorelease];
    errorView.delegate      = self;
    
    return errorView;
}

//----------------------------------------------------------------------------------------------------
- (id)getDelegateForClassName:(NSString*)className {
    return self;
}

//----------------------------------------------------------------------------------------------------
- (Class)presenterClassForClassName:(NSString*)className {
    return NSClassFromString([NSString stringWithFormat:@"%@%@",className,kPresenterClassSuffix]);
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)presentationStyleForClassName:(NSString*)className {
    NSString *style = [self.modelPresentationStyle objectForKey:className];
    return style ? [style integerValue] : kPresentationStyleDefault;
}

//----------------------------------------------------------------------------------------------------
- (NSString*)identifierForClassName:(NSString*)className 
                          withStyle:(NSInteger)style {
    
    return [NSString stringWithFormat:@"%@_%d",className,style];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDataSource

//----------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self getDataSource] totalSections];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self getDataSource] totalObjectsForSection:section];
}

//----------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    id object = [[self getDataSource] objectAtIndex:indexPath.row
                                         forSection:indexPath.section];
    
    NSString *className = [[object class] className];

    Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
    
	return [modelPresenter heightForObject:object
                     withPresentationStyle:[self presentationStyleForClassName:className]];
}

//----------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [[self getDataSource] objectAtIndex:indexPath.row
                                         forSection:indexPath.section];
    
    NSString *className     = [[object class] className];
    NSInteger style         = [self presentationStyleForClassName:className];
    NSString* identifier    = [self identifierForClassName:className 
                                                 withStyle:style];
    
    id cell                 = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
    
	return [modelPresenter cellForObject:object
                            withBaseCell:cell
                      withCellIdentifier:identifier
                            withDelegate:[self getDelegateForClassName:className]
                    andPresentationStyle:style];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITableViewDelegate

//----------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
    id object = [[self getDataSource] objectAtIndex:indexPath.row
                                         forSection:indexPath.section];
    
    NSString *className     = [[object class] className];
    NSInteger style         = [self presentationStyleForClassName:className];
    id cell                 = [self.tableView cellForRowAtIndexPath:indexPath];
    
    Class<DWModelPresenter> modelPresenter = [self presenterClassForClassName:className];
    
    [modelPresenter cellClickedForObject:object
                            withBaseCell:cell
                   withPresentationStyle:style
                            withDelegate:[self getDelegateForClassName:className]];
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
}

//----------------------------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWTableViewDataSourceDelegate

//----------------------------------------------------------------------------------------------------
- (void)reloadTableView {
    self.tableView.scrollEnabled    = YES;
    self.loadingView.hidden         = YES;
    self.errorView.hidden           = YES;
    
    [self.tableView reloadData];

    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    _isPullToRefreshActive          = NO;    
}

//----------------------------------------------------------------------------------------------------
- (void)displayError:(NSString *)message 
       withRefreshUI:(BOOL)showRefreshUI {
    
    SEL sel = @selector(setErrorMessage:);
    
    if(![self.errorView respondsToSelector:sel])
        return;
    
    [self.errorView performSelector:sel
                         withObject:message];
    
    
    sel = showRefreshUI ? @selector(showRefreshUI) : @selector(hideRefreshUI);
    
    if(![self.errorView respondsToSelector:sel])
        return;
    
    [self.errorView performSelector:sel];
    

    
    [self scrollToTop];
    
    self.loadingView.hidden         = YES;
    self.errorView.hidden           = NO;
    self.tableView.scrollEnabled    = NO;
    
    
    [self.tableView reloadData];
    
    _isPullToRefreshActive          = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

//----------------------------------------------------------------------------------------------------
- (void)displayError:(NSString *)message {
    
    [self displayError:message
         withRefreshUI:YES];
}

//----------------------------------------------------------------------------------------------------
- (void)insertRowAtIndex:(NSInteger)index {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                     inSection:0];
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationTop];
}

//----------------------------------------------------------------------------------------------------
- (void)removeRowAtIndex:(NSInteger)index withAnimation:(UITableViewRowAnimation)animation {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                 inSection:0];
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:animation];
}

//----------------------------------------------------------------------------------------------------
- (void)reloadRowAtIndex:(NSInteger)index {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:index
                                                 inSection:0];
    
    NSArray *indexPaths		= [NSArray arrayWithObjects:indexPath,nil];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationNone];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate 

//----------------------------------------------------------------------------------------------------
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    _isPullToRefreshActive = YES;
    [[self getDataSource] refreshInitiated];
}

//----------------------------------------------------------------------------------------------------
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
	return _isPullToRefreshActive; 
}

//----------------------------------------------------------------------------------------------------
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
	return nil;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Error view delegate

//----------------------------------------------------------------------------------------------------
- (void)errorViewTouched {
    self.loadingView.hidden = NO;
    self.errorView.hidden   = YES;
    [[self getDataSource] refreshInitiated];
}

@end
