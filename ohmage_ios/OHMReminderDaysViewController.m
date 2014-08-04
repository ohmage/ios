//
//  OHMReminderDaysViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderDaysViewController.h"
#import "OHMReminder.h"

@interface OHMReminderDaysViewController ()

@property (nonatomic, strong) OHMReminder *reminder;

@end

@implementation OHMReminderDaysViewController

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
    
    self.navigationItem.title = @"Repeat";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (OHMRepeatDay)repeatDayForRow:(NSInteger)row
{
    switch (row) {
        case 0:
            return OHMRepeatDaySunday;
        case 1:
            return OHMRepeatDayMonday;
        case 2:
            return OHMRepeatDayTuesday;
        case 3:
            return OHMRepeatDayWednesday;
        case 4:
            return OHMRepeatDayThursday;
        case 5:
            return OHMRepeatDayFriday;
        case 6:
            return OHMRepeatDaySaturday;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
    OHMRepeatDay day = [self repeatDayForRow:indexPath.row];
    cell.textLabel.text = [OHMReminder fullNameForRepeatDay:day];
    cell.accessoryType = ([self.reminder repeatDayIsOn:day] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMRepeatDay day = [self repeatDayForRow:indexPath.row];
    [self.reminder toggleRepeatForDay:day];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
