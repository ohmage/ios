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
        [self.locationManager setDistanceFilter:100.0f];
        [self.locationManager setDelegate:self];
        [self.locationManager startUpdatingLocation];
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];
        [self setGeocoder:[[CLGeocoder alloc] init]];
        [self debugPrintAllMonitoredRegions];
    }
    
    return self;
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
    
    CLLocationCoordinate2D coord = lastLocation.coordinate;
    NSLog(@"Location lat/long: %f,%f",coord.latitude, coord.longitude);
    
    CLLocationAccuracy horizontalAccuracy =
    lastLocation.horizontalAccuracy;
    
    NSLog(@"Horizontal accuracy: %f meters",horizontalAccuracy);
    
    CLLocationDistance altitude = lastLocation.altitude;
    NSLog(@"Location altitude: %f meters",altitude);
    
    CLLocationAccuracy verticalAccuracy =
    lastLocation.verticalAccuracy;
    
    NSLog(@"Vertical accuracy: %f meters",verticalAccuracy);
    
    NSDate *timestamp = lastLocation.timestamp;
    NSLog(@"Timestamp: %@",timestamp);
    
    CLLocationSpeed speed = lastLocation.speed;
    NSLog(@"Speed: %f meters per second",speed);
    
    CLLocationDirection direction = lastLocation.course;
    NSLog(@"Course: %f degrees from true north",direction);
    
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
        NSLog(@"Location Services Authorized");
        // Location services have just been authorized on the device, start updating now.
        [self.locationManager startUpdatingLocation];
        [self setLocationError:nil];
    }
}

#pragma mark - Region Monitoring delegate methods

- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    OHMReminderLocation *location = [[OHMClient sharedClient] locationWithOhmID:region.identifier];
    NSLog(@"did enter region: %@, reminderLocation: %@", region, location);
    if (location == nil) return;
    
    for (OHMReminder *reminder in location.reminders) {
        if ([[reminder.lastFireDate dateByAddingMinutes:reminder.minimumReentryIntervalValue]
             isBeforeDate:[NSDate date]]) {
        [[OHMReminderManager sharedReminderManager] scheduleNotificationForReminder:reminder];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    
}

@end
