//
//  DWLocationManager.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWLocationManager.h"
#import "DWAnalyticsManager.h"
#import "DWConstants.h"

#import "SynthesizeSingleton.h"


static NSInteger const kLocRefreshDistance			= 150;
static NSInteger const kLocationFreshnessThreshold	= 10;



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWLocationManager

@synthesize locationManager     = _locationManager;

SYNTHESIZE_SINGLETON_FOR_CLASS(DWLocationManager);

//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {
        self.locationManager					= [[CLLocationManager alloc] init];
        self.locationManager.delegate			= self;
        self.locationManager.desiredAccuracy	= kCLLocationAccuracyBest;
        self.locationManager.distanceFilter		= kLocRefreshDistance;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------
- (void)startLocationTracking {
    [self.locationManager startUpdatingLocation];
}

//----------------------------------------------------------------------------------------------------
- (void)stopLocationTracking {
    [self.locationManager stopUpdatingLocation];
}

//----------------------------------------------------------------------------------------------------
- (CLLocation*)getCurrentLocation {
    return self.locationManager.location;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark CLLocationManagerDelegate

//----------------------------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	
	if(fabs([newLocation.timestamp timeIntervalSinceNow]) < kLocationFreshnessThreshold) {
				
		[[NSNotificationCenter defaultCenter] postNotificationName:kNNewLocationAvailable 
															object:nil
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                        kKeyLocation,newLocation,
                                                                        nil]];
	}
    
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                             withActionName:@"new_location"
                                                               andExtraInfo:[NSString stringWithFormat:@"lat=%f&lon=%f",
                                                                             newLocation.coordinate.latitude,
                                                                             newLocation.coordinate.longitude]];
}

//----------------------------------------------------------------------------------------------------
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if([error code] == kCLErrorDenied) {
        
        [[DWAnalyticsManager sharedDWAnalyticsManager] createInteractionForView:self
                                                                 withActionName:@"location_denied"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNUserRejectedLocation 
															object:nil];
    }        
}




@end
