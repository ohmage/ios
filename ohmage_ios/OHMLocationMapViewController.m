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
#import "OHMRegionAnnotationView.h"
#import "OHMReminderViewController.h"

@interface OHMLocationMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) UISlider *radiusSlider;

@property (nonatomic, strong) OHMLocationManager *locationManager;
@property (nonatomic, strong) OHMReminderLocation *location;
@property (nonatomic, strong) OHMRegionAnnotationView *regionView;
@property (nonatomic, strong) MKOverlayRenderer *circleRenderer;

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

- (void)cancelButtonPressed:(id)sender
{
    [[OHMClient sharedClient] deleteObject:self.location];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonPressed:(id)sender
{
    [[OHMClient sharedClient] saveClientState];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[OHMReminderViewController class]]) {
            ((OHMReminderViewController *)vc).reminder.reminderLocation = self.location;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveButtonPressed:)];
    self.navigationItem.leftBarButtonItem = saveButton;
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    self.locationManager = [OHMLocationManager sharedLocationManager];
    
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:mapView];
    [self.view constrainChildToEqualSize:mapView];
    
    self.mapView = mapView;
    
    self.regionView = [[OHMRegionAnnotationView alloc] initWithAnnotation:self.location];
    self.regionView.map = self.mapView;
    
    [self.mapView addAnnotation:self.location];
    [self zoomToLocation];
    
    [self reverseGeocodeLocation:self.location];
    
    [self setupRadiusSlider];
}

- (void)setupRadiusSlider
{
    UISlider *slider = [[UISlider alloc] init];
    [slider addTarget:self action:@selector(updateRadiusFromSlider:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    [slider constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    [self.view constrainChildToDefaultHorizontalInsets:slider];
    self.radiusSlider = slider;
    [self updateSliderFromRadius];
}

- (void)updateRadiusFromSlider:(id)sender
{
    float val = self.radiusSlider.value;
    float scaledVal = kMinLocationRadius * powf(10, 2 * val);
    self.location.radiusValue = scaledVal;
//    [self.regionView radiusNeedsUpdate];
    [self.regionView updateRadiusOverlay];
}

- (void)updateSliderFromRadius
{
    double radius = self.location.radiusValue;
    double sliderVal = log10(radius / kMinLocationRadius) / 2.0;
    self.radiusSlider.value = sliderVal;
}

- (void)zoomToLocation
{
    CLLocationCoordinate2D coordinate = self.location.coordinate;
    CLLocationDistance distance = self.location.radiusValue;
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance);
    
    MKMapPoint pt = MKMapPointForCoordinate(self.location.coordinate);
    double w = MKMapPointsPerMeterAtLatitude(self.location.coordinate.latitude) * self.location.radiusValue * 0.5;
    self.mapView.visibleMapRect = MKMapRectMake(pt.x - w/2.0, pt.y - w/2.0, w, w);
    
//    reg = [self.mapView regionThatFits:reg];
//    self.mapView.region = reg;
//    [self.mapView setRegion:reg animated:YES];
//    MKCoordinateSpan newSpan = self.mapView.region.span;
//    NSLog(@"zoom to coordinate, distance: %f, %f %f adjusted: %f %f", distance, reg.span.longitudeDelta, reg.span.latitudeDelta, newSpan.longitudeDelta, newSpan.latitudeDelta);
    [self.regionView updateRadiusOverlay];
}

#pragma mark - Map View Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"map view did update user location, is updating: %d, accuracy: %f", userLocation.isUpdating, userLocation.location.horizontalAccuracy);
    if (self.isCurrentLocation) {
        self.location.coordinate = userLocation.coordinate;
        [self zoomToLocation];
//        self.isCurrentLocation = NO; //we only want one update
    }
}

//- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
//{
//    NSLog(@"region with change, animated: %d", animated);
//}
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
//{
//    NSLog(@"region did change, animated: %d", animated);
//}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isEqual:self.location]) {
        [self.regionView updateRadiusOverlay];  
        return self.regionView;
    }
	
	return nil;
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
        MKCircleRenderer *circleView =
        [[MKCircleRenderer alloc] initWithCircle:overlay];
        
        circleView.fillColor =
        [[UIColor blueColor] colorWithAlphaComponent:0.2];
        
        circleView.strokeColor =
        [[UIColor blueColor] colorWithAlphaComponent:0.7];
        
        circleView.lineWidth = 2;
        
        self.circleRenderer = circleView;
		
		return circleView;
	}
	
	return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView
                                 didChangeDragState:(MKAnnotationViewDragState)newState
                                       fromOldState:(MKAnnotationViewDragState)oldState {
    
    if ([annotationView isEqual:self.regionView]) {
		
		// If the annotation view is starting to be dragged, remove the overlay.
		if (newState == MKAnnotationViewDragStateStarting) {
			[self.regionView removeRadiusOverlay];
		}
		
		// Once the annotation view has been dragged and placed in a new location, update and add the overlay.
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[self.regionView updateRadiusOverlay];

            [self reverseGeocodeLocation:self.location];
		}
	}
}

#pragma mark -
- (void)reverseGeocodeLocation:(OHMReminderLocation *)location
{
    CLGeocoder *geocoder = self.locationManager.geocoder;
    
    CLLocationCoordinate2D draggedCoord = location.coordinate;
    
    CLLocation *draggedLocation =
    [[CLLocation alloc] initWithLatitude:draggedCoord.latitude
                               longitude:draggedCoord.longitude];
    
    [geocoder reverseGeocodeLocation:draggedLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (error)
                       {
                           UIAlertView *alert =
                           [[UIAlertView alloc] initWithTitle:@"Geocoding Error"
                                                      message:error.localizedDescription
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles: nil];
                           
                           [alert show];
                       } else
                       {
                           if ([placemarks count] > 0) {
                               CLPlacemark *placemark = [placemarks lastObject];
                               NSLog(@"placemark: %@", placemark);
//                               NSLog(@"thoroughfare")
//                               [location updateWithPlacemark:placemark];
//                               location.name = placemark.name;
                               location.name = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
                           }
                           
                       }
                   }];
}

@end
