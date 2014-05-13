//
//  OHMReminderLocationViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderLocationViewController.h"
#import "OHMLocationSearchViewController.h"
#import "OHMReminderLocation.h"
#import "OHMReminder.h"

@interface OHMReminderLocationViewController ()

@property (nonatomic, strong) OHMReminder *reminder;
@property (nonatomic, strong) NSFetchedResultsController *fetchedLocationsController;

@end

@implementation OHMReminderLocationViewController

- (instancetype)initWithReminder:(OHMReminder *)reminder
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Location";
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
        cell.detailTextLabel.text = location.locationText;
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
        self.reminder.reminderLocation = self.fetchedLocationsController.fetchedObjects[indexPath.row - 1];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
