//
//  DWModelPresenter.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Required protocol for all model presenters
 */
@protocol DWModelPresenter

/**
 * Setup the cell for being displayed in a table view. Optionally
 * allocate memory if the base cell is nil
 */
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style;

/**
 * Compute the height for the given object
 */
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style;

/**
 * Update the cell when a new resource is made available
 */
+ (void)updatePresentationForCell:(id)base
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withNewResource:(id)resource
                 havingResourceID:(NSInteger)resourceID
                           ofType:(NSInteger)resourceType;

@end
