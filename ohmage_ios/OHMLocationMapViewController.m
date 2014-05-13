//
//  OHMReminderMapViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMLocationMapViewController.h"
#import <MapKit/MapKit.h>
#import "OHMReminder.h"
#import "OHMReminderLocation.h"
#import "OHMLocationManager.h"

@interface OHMLocationMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) OHMReminderLocation *location;
@property (nonatomic, strong) MKMapItem *mapItem;

@property (nonatomic, strong) OHMLocationManager *locationManager;

@end

@implementation OHMLocationMapViewController

- (instancetype)initWithLocation:(OHMReminderLocation *)location
{
    self = [super init];
    if (self) {
        self.location = location;
    }
    return self;
}

- (instancetype)initWithMapItem:(MKMapItem *)mapItem
{
    self = [super init];
    if (self) {
        self.mapItem = mapItem;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:mapView];
    [self.view constrainChildToEqualSize:mapView];
    
    self.mapView = mapView;
    
    [self.mapView addAnnotation:self.mapItem.placemark];
    
    if (self.mapItem.isCurrentLocation) {
        [self zoomToCoordinate:self.locationManager.location.coordinate];
    }
    else {
        [self zoomToCoordinate:self.mapItem.placemark.coordinate];
    }
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"zoom to coordinate");
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    self.mapView.region = reg;
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"map view did update user location: %@", userLocation);
}

@end
