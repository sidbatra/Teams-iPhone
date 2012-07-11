//
//  DWLocationManager.h
//  Copyright 2011 Denwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 * Wrapper around the device location services
 */
@interface DWLocationManager : NSObject <CLLocationManagerDelegate> {
    CLLocationManager		*_locationManager;
}

/**
 * Shared sole instance of the class
 */
+ (DWLocationManager *)sharedDWLocationManager;

/**
 * iOS location services interface
 */
@property (nonatomic) CLLocationManager *locationManager;


/**
 * Start tracking the device location
 */
- (void)startLocationTracking;

/**
 * Stop tracking the device location
 */
- (void)stopLocationTracking;

/**
 * Get the current estimate of the device location
 */ 
- (CLLocation*)getCurrentLocation;

@end
