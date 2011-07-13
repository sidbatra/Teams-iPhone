//
//  DWPagination.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Pagination model used to inject a pagination cell into table views
 */
@interface DWPagination : NSObject {
    BOOL    _isTriggered;
    id      _owner;
}

/**
 * Indicates if pagination has been triggered
 */
@property (nonatomic,assign) BOOL isTriggered;

/**
 * Owner of the pagination model
 */
@property (nonatomic,assign) id owner;

@end
