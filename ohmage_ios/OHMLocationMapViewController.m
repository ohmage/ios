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

@interface OHMLocationMapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) OHMReminderLocation *location;
//@property (nonatomic, strong) MKMapItem *mapItem;

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
//        self.mapItem = mapItem;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
    
    MKMapView *mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    
    [self.view addSubview:mapView];
    [self.view constrainChildToEqualSize:mapView];
    
    self.mapView = mapView;
    [self.mapView addAnnotation:self.location];
    [self zoomToCoordinate:self.location.coordinate];
    
    
//    [self.mapView addAnnotation:self.mapItem.placemark];
//    
//    if (self.mapItem.isCurrentLocation) {
//        [self zoomToCoordinate:self.locationManager.location.coordinate];
//    }
//    else {
//        [self zoomToCoordinate:self.mapItem.placemark.coordinate];
//    }
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"zoom to coordinate");
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    self.mapView.region = reg;
}

#pragma mark - Map View Delegate

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if([annotation isKindOfClass:[OHMReminderLocation class]]) {
		OHMReminderLocation *currentAnnotation = (OHMReminderLocation *)annotation;
		NSString *annotationIdentifier = [currentAnnotation title];
		OHMRegionAnnotationView *regionView = (OHMRegionAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		
		if (!regionView) {
			regionView = [[OHMRegionAnnotationView alloc] initWithAnnotation:annotation];
			regionView.map = self.mapView;
		} else {
			regionView.annotation = annotation;
			regionView.theAnnotation = currentAnnotation;
		}
		
		// Update or add the overlay displaying the radius of the region around the annotation.
		[regionView updateRadiusOverlay];
		
		return regionView;
	}
	
	return nil;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
		circleView.strokeColor = [UIColor purpleColor];
		circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
		
		return circleView;
	}
	
	return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if([annotationView isKindOfClass:[OHMRegionAnnotationView class]]) {
		OHMRegionAnnotationView *regionView = (OHMRegionAnnotationView *)annotationView;
		OHMReminderLocation *regionAnnotation = (OHMReminderLocation *)regionView.annotation;
		
		// If the annotation view is starting to be dragged, remove the overlay and stop monitoring the region.
		if (newState == MKAnnotationViewDragStateStarting) {
			[regionView removeRadiusOverlay];
		}
		
		// Once the annotation view has been dragged and placed in a new location, update and add the overlay and begin monitoring the new region.
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[regionView updateRadiusOverlay];
			
			CLRegion *newRegion = [[CLCircularRegion alloc] initWithCenter:regionAnnotation.coordinate radius:regionAnnotation.radiusValue identifier:regionAnnotation.ohmID];
			regionAnnotation.region = newRegion;
		}
	}
}

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    NSLog(@"map view did update user location: %@", userLocation);
//}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if (annotation == mapView.userLocation) {
//        return nil;
//    }
//
//	MKPinAnnotationView *annotationView = nil;
//    annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
//    if (annotationView == nil)
//    {
//        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
//        annotationView.canShowCallout = YES;
//        annotationView.animatesDrop = YES;
//        annotationView.draggable = YES;
//    }
//    
//	return annotationView;
//}
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
//{
//    if (newState == MKAnnotationViewDragStateEnding) {
//        
//        UIActivityIndicatorViewStyle whiteStyle =
//        UIActivityIndicatorViewStyleWhite;
//        
//        UIActivityIndicatorView *activityView =
//        [[UIActivityIndicatorView alloc]
//         initWithActivityIndicatorStyle:whiteStyle];
//        
//        [activityView startAnimating];
//        [annotationView setLeftCalloutAccessoryView:activityView];
//        
//        [self reverseGeocodeDraggedAnnotationView:annotationView];
//    }
//}

#pragma mark -
- (void)reverseGeocodeDraggedAnnotationView:(MKAnnotationView *)annotationView
{
    CLGeocoder *geocoder = self.locationManager.geocoder;
    id<MKAnnotation> annotation = annotationView.annotation;
    
    CLLocationCoordinate2D draggedCoord = [annotation coordinate];
    
    CLLocation *draggedLocation =
    [[CLLocation alloc] initWithLatitude:draggedCoord.latitude
                               longitude:draggedCoord.longitude];
    
    [geocoder reverseGeocodeLocation:draggedLocation
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       UIImage *arrowImage =
                       [UIImage imageNamed:@"annotation_view_arrow"];
                       
                       UIImageView *leftView =
                       [[UIImageView alloc] initWithImage:arrowImage];
                       
                       [annotationView setLeftCalloutAccessoryView:leftView];
                       
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
//                               [self updateFavoritePlace:place withPlacemark:placemark];
                           }
                           
                       }
                   }];
}

@end
