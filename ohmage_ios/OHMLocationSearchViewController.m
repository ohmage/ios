//
//  OHMLocationSearchViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMLocationSearchViewController.h"
#import <MapKit/MapKit.h>
#import "OHMLocationMapViewController.h"
#import "OHMLocationManager.h"
#import "OHMReminderLocation.h"

@interface OHMLocationSearchViewController () <UISearchBarDelegate, OHMLocationManagerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *places;
@property (nonatomic, strong) OHMLocationManager *locationManager;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;

@end

@implementation OHMLocationSearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Search";
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, self.tableView.rowHeight)];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search or Enter Address";
    self.tableView.tableHeaderView = searchBar;
    self.searchBar = searchBar;
    
    self.locationManager = [OHMLocationManager sharedLocationManager];
    self.locationManager.delegate = self;
}

- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = self.places.count;
    if (self.locationManager.hasLocation) rows++;
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == 0 && self.locationManager.hasLocation) {
        cell.textLabel.text = @"Current location";
    }
    else {
        NSInteger row = indexPath.row;
        if (self.locationManager.hasLocation) row--;
        MKMapItem *mapItem = self.places[row];
        cell.textLabel.text = mapItem.name;
    }
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLLocationCoordinate2D coordinate;
    BOOL isCurrentLocation = NO;
    if (indexPath.row == 0 && self.locationManager.hasLocation) {
        coordinate = self.locationManager.location.coordinate;
        isCurrentLocation = YES;
    }
    else {
        NSInteger row = indexPath.row;
        if (self.locationManager.hasLocation) row--;
        MKMapItem *mapItem = self.places[row];
        coordinate = mapItem.placemark.coordinate;
    }
    
    OHMReminderLocation *location = [[OHMModel sharedModel] insertNewReminderLocation];
    location.coordinate = coordinate;
    
    OHMLocationMapViewController *vc = [[OHMLocationMapViewController alloc] initWithLocation:location];
    vc.isCurrentLocation = isCurrentLocation;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (MKCoordinateRegion)userRegion
{
    // confine the map search area to the user's current location
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    
    // setup the area spanned by the map region:
    // we use the delta values to indicate the desired zoom level of the map,
    //      (smaller delta values corresponding to a higher zoom level)
    //
    region.span.latitudeDelta = 0.112872;
    region.span.longitudeDelta = 0.109863;
    
    return region;
}

- (MKCoordinateRegion)worldRegion
{
    return MKCoordinateRegionForMapRect(MKMapRectWorld);
}

- (void)startSearch:(NSString *)searchString
{
    if (self.localSearch.searching)
    {
        [self.localSearch cancel];
    }
    
    MKCoordinateRegion region;
    if (self.locationManager.hasLocation) {
        region = [self userRegion];
    }
    else {
        region = [self worldRegion];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    
    request.naturalLanguageQuery = searchString;
    request.region = region;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error)
    {
        if (error != nil)
        {
            NSString *errorStr = [[error userInfo] valueForKey:NSLocalizedDescriptionKey];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not find places"
                                                            message:errorStr
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            self.places = [response mapItems];
            
            // used for later when setting the map's region in "prepareForSegue"
            self.boundingRegion = response.boundingRegion;
            
//            self.viewAllButton.enabled = self.places != nil ? YES : NO;
            
            [self.tableView reloadData];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    
    if (self.localSearch != nil)
    {
        self.localSearch = nil;
    }
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:completionHandler];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // check to see if Location Services is enabled, there are two state possibilities:
    // 1) disabled for entire device, 2) disabled just for this app
    //
    NSString *causeStr = nil;
    
    // check whether location services are enabled on the device
    if ([CLLocationManager locationServicesEnabled] == NO)
    {
        causeStr = @"device";
    }
    // check the application’s explicit authorization status:
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        causeStr = @"app";
    }
    else
    {
        // we are good to go, start the search
        [self startSearch:searchBar.text];
    }
    
    if (causeStr != nil)
    {
        NSString *alertMessage = [NSString stringWithFormat:@"You currently have location services disabled for this %@. Please refer to \"Settings\" app to turn on Location Services.", causeStr];
        
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:alertMessage
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
        [servicesDisabledAlert show];
    }
}

#pragma mark - OHMLocationManager Delegate

- (void)OHMLocationManagerDidUpdateLocation:(OHMLocationManager *)locationManager
{
    [self.tableView reloadData];
}


@end
