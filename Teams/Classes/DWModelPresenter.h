//
//  DWModelPresenter.h
//  DWTableViewDataSource.h
//

#import <Foundation/Foundation.h>

/**
 * Required protocol for all model presenters
 */
@protocol DWModelPresenter

+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
             andPresentationStyle:(NSInteger)style;

+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style;

@end
