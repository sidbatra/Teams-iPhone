//
//  DWSearchController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWSearchControllerDelegate;

/**
 * Interface to the search service on the app server
 */
@interface DWSearchController : NSObject {
    
    id<DWSearchControllerDelegate,NSObject>  __unsafe_unretained _delegate;
}

/**
 * Delegate recieves events based on the DWSearchControllerDelegate protocol
 */
@property (nonatomic,unsafe_unretained) id<DWSearchControllerDelegate,NSObject> delegate;


/**
 * Get search results for the given query
 */
- (void)getSearchResultsForQuery:(NSString*)query;

@end


/**
 * Protocol for the delegate of DWSearchController
 */
@protocol DWSearchControllerDelegate

/**
 * Fired when the search is successful. 
 * Results contains a mix of different models
 */
- (void)searchLoaded:(NSMutableArray*)results;

/**
 * Fired when there is an error loading search results
 */
- (void)searchLoadError:(NSString*)error;

@end
