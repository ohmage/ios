//
//  OHMReminderLocationViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderLocationViewController.h"
#import <MapKit/MapKit.h>
#import "OHMReminder.h"

@interface OHMReminderLocationViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;

@property (nonatomic, strong) OHMReminder *reminder;

@end

@implementation OHMReminderLocationViewController

- (instancetype)initWithReminder:(OHMReminder *)reminder
{
    self = [super init];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:mapView];
    [self.view constrainChildToEqualSize:mapView];
    
    self.mapView = mapView;
    
    if (mapView.userLocation != nil) {
        [self zoomToUserLocation:mapView.userLocation];
    }
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"zoom to user location");
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MKCoordinateRegion reg =
    MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    self.mapView.region = reg;
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"map view did update user location: %@", userLocation);
    [self zoomToUserLocation:userLocation];
}

@end
