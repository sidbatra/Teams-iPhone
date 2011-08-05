//
//  DWContactsController.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWContactsControllerDelegate;

/**
 * Interface to the local address book on the iOS client
 */
@interface DWContactsController : NSObject {
    
    id<DWContactsControllerDelegate,NSObject>  _delegate;
}

/**
 * Delegate recieves events based on the DWSearchControllerDelegate protocol
 */
@property (nonatomic,assign) id<DWContactsControllerDelegate,NSObject> delegate;


/**
 * Get all contacts
 */
- (void)getAllContacts;

/**
 * Get contacts whose properties contain a 
 * given string
 */
- (void)getContactsForQuery:(NSString*)query 
                  withCache:(NSArray*)allContacts;

@end

/**
 * Protocol for the delegate of DWContactsController
 */
@protocol DWContactsControllerDelegate

/**
 * Fired when all contacts are loaded from the 
 * address book
 */
- (void)allContactsLoaded:(NSArray*)contacts; 

/**
 * Fired when the contacts are loaded in the memory
 * Array contains objects for DWContact having 
 * fullname and email of the contact.
 */
- (void)contactsLoaded:(NSMutableArray*)contacts 
             fromQuery:(NSString*)query;

@end
