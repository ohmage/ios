//
//  OHMLocationManager.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMLocationManager.h"
#import "OHMReminderManager.h"
#import "OHMReminder.h"
#import "OHMReminderLocation.h"


@interface OHMLocationManager ()
@property (strong, nonatomic) NSMutableArray *completionBlocks;
@end

@implementation OHMLocationManager

+ (OHMLocationManager *)sharedLocationManager
{
    static OHMLocationManager *_sharedLocationManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationManager = [[OHMLocationManager alloc] init];
    });
    
    return _sharedLocationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setLocationManager:[[CLLocationManager alloc] init]];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager setDistanceFilter:20.0f]; //todo: what should this be?
        [self.locationManager setDelegate:self];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [self.locationManager performSelector:@selector(requestAlwaysAuthorization)];
            }
        }
        
        [self.locationManager startUpdatingLocation];
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];
        [self setGeocoder:[[CLGeocoder alloc] init]];
    }
    
    return self;
}

- (void)stopMonitoringAllRegions
{
    NSSet *monitoredRegions = self.locationManager.monitoredRegions;
    for (CLRegion *region in monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

- (void)debugPrintAllMonitoredRegions
{
    NSSet *monitoredRegions = self.locationManager.monitoredRegions;
    NSLog(@"There are %lu monitored regions.", (unsigned long)monitoredRegions.count);
    for (CLRegion *region in monitoredRegions) {
        NSLog(@"Region: %@", region);
    }
}

#pragma mark -
- (void)getLocationWithCompletionBlock:(OHMLocationUpdateCompletionBlock)block
{
    if (block)
    {
        [self.completionBlocks addObject:[block copy]];
    }
    
    if (self.hasLocation)
    {
        for (OHMLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(self.location, nil);
        }
        if ([self.completionBlocks count] == 0) {
            //notify map view of change to location when not requested
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationUpdated" object:nil];
        }
        
        [self.completionBlocks removeAllObjects];
    }
    
    if (self.locationError) {
        for (OHMLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
        {
            completionBlock(nil, self.locationError);
        }
        [self.completionBlocks removeAllObjects];
    }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //Filter out inaccurate points
    CLLocation *lastLocation = [locations lastObject];
    if(lastLocation.horizontalAccuracy < 0)
    {
        return;
    }
    
    [self setLocation:lastLocation];
    [self setHasLocation:YES];
    [self setLocationError:nil];
    
    [self getLocationWithCompletionBlock:nil];
    
    if ([self.delegate respondsToSelector:@selector(OHMLocationManagerDidUpdateLocation:)]) {
        [self.delegate OHMLocationManagerDidUpdateLocation:self];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    [self setLocationError:error];
    [self getLocationWithCompletionBlock:nil];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied)
    {
        // Location services are disabled on the device.
        [self.locationManager stopUpdatingLocation];
        self.isAuthorized = NO;
        
        NSString *errorMessage =
        @"Location Services Permission Denied for this app.  Visit Settings.app to allow.";
        
        NSDictionary *errorInfo =
        @{NSLocalizedDescriptionKey : errorMessage};
        
        NSError *deniedError =
        [NSError errorWithDomain:@"OHMLocationErrorDomain"
                            code:1
                        userInfo:errorInfo];
        
        [self setLocationError:deniedError];
        [self getLocationWithCompletionBlock:nil];
    }
    if (status == kCLAuthorizationStatusAuthorized)
    {
        // Location services have just been authorized on the device, start updating now.
        [self.locationManager startUpdatingLocation];
        [self setLocationError:nil];
        self.isAuthorized = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(OHMLocationManagerAuthorizationStatusChanged:)]) {
        [self.delegate OHMLocationManagerAuthorizationStatusChanged:self];
    }
}

#pragma mark - Region Monitoring delegate methods

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    OHMReminderLocation *location = [[OHMModel sharedModel] locationWithUUID:region.identifier];
    
    if (location == nil) return;
    
    for (OHMReminder *reminder in location.reminders) {
        [[OHMReminderManager sharedReminderManager] processArrivalAtLocationForReminder:reminder];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

@end
