//
//  OHMManageLocationsViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/15/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMManageLocationsViewController.h"
#import "OHMLocationSearchViewController.h"
#import "OHMLocationMapViewController.h"
#import "OHMReminderLocation.h"

@interface OHMManageLocationsViewController ()

@property (nonatomic, strong) OHMReminder *reminder;
@property (nonatomic, strong) NSFetchedResultsController *fetchedLocationsController;

@end

@implementation OHMManageLocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Manage";
    
    self.fetchedLocationsController = [[OHMModel sharedModel] fetchedResultsControllerWithEntityName:[OHMReminderLocation entityName]
                                                                                               sortKey:@"name"
                                                                                             predicate:nil
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.fetchedLocationsController performFetch:nil];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedLocationsController fetchedObjects] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
        cell.textLabel.text = @"New location";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        OHMReminderLocation *location = self.fetchedLocationsController.fetchedObjects[indexPath.row - 1];
        cell = [OHMUserInterface cellWithSubtitleStyleFromTableView:tableView];
        cell.textLabel.text = location.name;
        cell.detailTextLabel.text = location.streetAddress;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        OHMLocationSearchViewController *vc = [[OHMLocationSearchViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        OHMReminderLocation *location = self.fetchedLocationsController.fetchedObjects[indexPath.row - 1];
        OHMLocationMapViewController *vc = [[OHMLocationMapViewController alloc] initWithLocation:location];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
