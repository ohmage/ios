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

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL hasLocation;
@property (nonatomic, strong) NSError *locationError;
@property (strong, nonatomic) CLGeocoder *geocoder;

- (void)getLocationWithCompletionBlock:(OHMLocationUpdateCompletionBlock)block;
- (void)stopMonitoringAllRegions;
- (void)debugPrintAllMonitoredRegions;


@end

@protocol OHMLocationManagerDelegate <NSObject>
@optional

- (void)OHMLocationManagerDidUpdateLocation:(OHMLocationManager *)locationManager;

@end