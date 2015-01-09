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

#define STALE_INTERVAL 60

@interface OHMLocationManager ()
@property (strong, nonatomic) NSMutableArray *completionBlocks;
@property (nonatomic, assign) BOOL trackingForMap;
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
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone]; //todo: what should this be?
        [self.locationManager setDelegate:self];
        
        [self setCompletionBlocks:[[NSMutableArray alloc] initWithCapacity:3.0]];
        [self setGeocoder:[[CLGeocoder alloc] init]];
    }
    
    return self;
}

- (void)requestAuthorization
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager performSelector:@selector(requestAlwaysAuthorization)];
        }
    }
}

- (BOOL)isAuthorized
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

- (BOOL)currentLocationIsStale
{
    NSLog(@"current location is stale: %d", (self.locationManager.location == nil || [self.locationManager.location.timestamp timeIntervalSinceNow] < -STALE_INTERVAL));
    if (self.locationManager.location == nil) return YES;
    return ([self.locationManager.location.timestamp timeIntervalSinceNow] < -STALE_INTERVAL);
}

- (BOOL)hasLocation
{
    return ![self currentLocationIsStale];
}

- (CLLocation *)location
{
    if ([self currentLocationIsStale]) {
        return nil;
    }
    else {
        return self.locationManager.location;
    }
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
    
    if ([self hasLocation]) {
        [self performCompletionBlocksWithLocation:self.location error:nil];
    }
    else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)performCompletionBlocksWithLocation:(CLLocation *)location error:(NSError *)error
{
    for (OHMLocationUpdateCompletionBlock completionBlock in self.completionBlocks)
    {
        completionBlock(location, error);
    }
    [self.completionBlocks removeAllObjects];
}

- (void)startUpdatingLocationForMap
{
    self.trackingForMap = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocationForMap
{
    self.trackingForMap = NO;
    [self.locationManager stopUpdatingLocation];
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
    
    NSLog(@"got location with accuracy: %g, numBlocks: %d", lastLocation.horizontalAccuracy, (int)self.completionBlocks.count);
    
    [self setLocationError:nil];
    [self performCompletionBlocksWithLocation:lastLocation error:nil];
    
    if ([self.delegate respondsToSelector:@selector(OHMLocationManagerDidUpdateLocation:)]) {
        [self.delegate OHMLocationManagerDidUpdateLocation:self];
    }
    
    if (!self.trackingForMap) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    [self setLocationError:error];
    
    [self performCompletionBlocksWithLocation:nil error:error];
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
        [self performCompletionBlocksWithLocation:nil error:deniedError];
    }
    if (status == kCLAuthorizationStatusAuthorized)
    {
        [self setLocationError:nil];
        
        // Location services have just been authorized on the device, start updating if needed.
        if (self.completionBlocks.count > 0) {
            [self.locationManager startUpdatingLocation];
        }
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
