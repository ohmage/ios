//
//  OHMLocationManager.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^OHMLocationUpdateCompletionBlock)(CLLocation *location, NSError *error);

@protocol OHMLocationManagerDelegate;

@interface OHMLocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedLocationManager;

@property (nonatomic, weak) id<OHMLocationManagerDelegate> delegate;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, readonly) BOOL isAuthorized;
@property (nonatomic, readonly) BOOL hasLocation;
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, strong) NSError *locationError;
@property (strong, nonatomic) CLGeocoder *geocoder;

- (void)requestAuthorization;
- (void)getLocationWithCompletionBlock:(OHMLocationUpdateCompletionBlock)block;
- (void)startUpdatingLocationForMap;
- (void)stopUpdatingLocationForMap;
- (void)stopMonitoringAllRegions;
- (void)debugPrintAllMonitoredRegions;


@end

@protocol OHMLocationManagerDelegate <NSObject>
@optional

- (void)OHMLocationManagerDidUpdateLocation:(OHMLocationManager *)locationManager;
- (void)OHMLocationManagerAuthorizationStatusChanged:(OHMLocationManager *)locationManager;

@end