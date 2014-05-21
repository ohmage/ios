//
//  OHMReminderViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/30/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderViewController.h"
#import "OHMReminderDaysViewController.h"
#import "OHMReminderReentryViewController.h"
#import "OHMReminderLocationViewController.h"
//#import "OHMManageLocationsViewController.h"
#import "OHMLocationSearchViewController.h"
#import "OHMReminder.h"
#import "OHMReminderLocation.h"
#import "OHMSurvey.h"
#import "OHMReminderManager.h"
#import "OHMLocationManager.h"

static NSString *const kAlwaysShowCellTitle = @"Always show reminder";
static NSString *const kAlwaysShowCellSubtitle = @"Show reminder at end time if location isn't reached";

typedef NS_ENUM(NSUInteger, RowIndex) {
    eRowIndexTimeOrLocation = 0,
    eRowIndexRangeEnable,
    eRowIndexRangeStart,
    eRowIndexRangeEnd,
    eRowIndexRepeat,
    eRowIndexMinimumReentry,
    eRowIndexAlwaysShow
};


@interface OHMReminderViewController ()

@property (nonatomic, strong) UISegmentedControl *timeOrLocationControl;
@property (nonatomic, strong) UISwitch *rangeEnableSwitch;
@property (nonatomic, strong) UIDatePicker *alarmTimePicker;
@property (nonatomic, strong) UIDatePicker *startTimePicker;
@property (nonatomic, strong) UIDatePicker *endTimePicker;
@property (nonatomic, strong) UITableViewCell *alarmTimePickerCell;
@property (nonatomic, strong) UITableViewCell *startTimePickerCell;
@property (nonatomic, strong) UITableViewCell *endTimePickerCell;

@property (nonatomic, strong) NSIndexPath *timePickerPath;

@end

@implementation OHMReminderViewController

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
    
    self.navigationItem.title = ([self.reminder.objectID isTemporaryID] ? @"New Reminder" : @"Edit Reminder");
    self.navigationItem.leftBarButtonItem = self.doneButton;
    [self setBackButtonTitle:@""];
    
    self.view.tintColor = [OHMAppConstants colorForSurveyIndex:self.reminder.survey.indexValue];
    
    [self setupTimePickers];
    
    UISegmentedControl *timeOrLocationControl = [[UISegmentedControl alloc] initWithItems:@[@"Time Reminder", @"Location Reminder"]];
    timeOrLocationControl.frame = CGRectMake(0, 0, 0, 30);
    timeOrLocationControl.backgroundColor = [UIColor whiteColor];
    timeOrLocationControl.selectedSegmentIndex = self.reminder.isLocationReminderValue;
    [timeOrLocationControl addTarget:self action:@selector(timeOrLocationControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    BOOL canUseLocation = ([OHMLocationManager sharedLocationManager].locationError == nil);
    [timeOrLocationControl setEnabled:canUseLocation forSegmentAtIndex:1];
    self.timeOrLocationControl = timeOrLocationControl;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectInset(timeOrLocationControl.frame, 0, -kUIViewSmallMargin)];
    [headerView addSubview:timeOrLocationControl];
    [timeOrLocationControl constrainToTopInParentWithMargin:kUIViewSmallMargin];
    [headerView constrainChild:timeOrLocationControl toHorizontalInsets:UIEdgeInsetsMake(0, kUIViewSmallMargin, 0, kUIViewSmallMargin)];
    self.tableView.tableHeaderView = headerView;
    
    if (!self.reminder.objectID.isTemporaryID) {
        self.tableView.tableFooterView = [OHMUserInterface tableFooterViewWithButton:@"Delete Reminder" fromTableView:self.tableView setupBlock:^(UIButton *button) {
            [button addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [[UIColor redColor] lightColor];
        }];
    }
    else {
        self.navigationItem.rightBarButtonItem = self.cancelButton;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
    [self.tableView reloadData];
    [self updateDoneButtonEnabledState];
}

- (void)updateDoneButtonEnabledState
{
    self.doneButton.enabled = (!self.reminder.isLocationReminderValue
                               || (self.reminder.reminderLocation != nil) );
}

- (void)doneButtonPressed:(id)sender
{
    if (self.reminder.usesTimeRangeValue) {
        self.reminder.startTime = self.startTimePicker.date;
        self.reminder.endTime = self.endTimePicker.date;
    }
    else {
        self.reminder.specificTime = self.alarmTimePicker.date;
    }
    
    [[OHMReminderManager sharedReminderManager] updateScheduleForReminder:self.reminder];
    [[OHMClient sharedClient] saveClientState];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(id)sender
{
    [[OHMClient sharedClient] deleteObject:self.reminder];
    [[OHMClient sharedClient] saveClientState];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteButtonPressed:(id)sender
{
    [self presentConfirmationAlertWithTitle:@"Delete reminder?" message:@"Are you sure you want to delete this reminder?" confirmTitle:@"Delete"];
}

- (void)confirmationAlertDidConfirm:(UIAlertView *)alert
{
    NSLog(@"Delete alert did confirm");
    
    [self cancelButtonPressed:nil];
}


- (void)setupTimePickers
{
    self.alarmTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        [dp addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (self.reminder.specificTime != nil) {
            dp.date = self.reminder.specificTime;
        }
        self.alarmTimePicker = dp;
    }];
    
    self.startTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        [dp addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (self.reminder.startTime != nil) {
            dp.date = self.reminder.startTime;
        }
        self.startTimePicker = dp;
    }];
    
    self.endTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        [dp addTarget:self action:@selector(timePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        if (self.reminder.endTime != nil) {
            dp.date = self.reminder.endTime;
        }
        else {
            dp.date = [self.startTimePicker.date dateByAddingHours:1];
        }
        self.endTimePicker = dp;
    }];
}

- (void)timeOrLocationControlValueChanged:(id)sender
{
    // hide reminderTime picker if needed before updating isLocationReminderValue
    if (self.timeOrLocationControl.selectedSegmentIndex == 1) {
        NSIndexPath *timeReminderPickerPath = [NSIndexPath indexPathForRow:eRowIndexTimeOrLocation + 1 inSection:0];
        if ([self.timePickerPath isEqual:timeReminderPickerPath]) {
            [self toggleTimePickerForIndexPath:[self indexPathForRow:eRowIndexTimeOrLocation]];
        }
    }
    
    self.reminder.isLocationReminderValue = self.timeOrLocationControl.selectedSegmentIndex;
    
    NSMutableArray *paths = [NSMutableArray arrayWithObject:[self indexPathForRow:eRowIndexMinimumReentry]];
    if (self.reminder.usesTimeRangeValue) {
        [paths addObject:[self indexPathForRow:eRowIndexAlwaysShow]];
    }
    
    if (self.reminder.isLocationReminderValue) {
        [self insertRowsAtIndexPaths:paths];
    }
    else {
        [self deleteRowsAtIndexPaths:paths];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[self indexPathForRow:eRowIndexTimeOrLocation]] withRowAnimation:UITableViewRowAnimationFade];
    [self updateDoneButtonEnabledState];
}

- (void)timeRangeEnableSwitchToggled:(id)sender
{
    // hide time picker if needed
    if (!self.rangeEnableSwitch.on && self.timePickerPath != nil && self.timePickerPath.row > 1) {
        NSIndexPath *togglePath = [NSIndexPath indexPathForRow:self.timePickerPath.row - 1 inSection:0];
        [self toggleTimePickerForIndexPath:togglePath];
    }
    
    self.reminder.usesTimeRangeValue = self.rangeEnableSwitch.on;
    NSArray *paths = @[[self indexPathForRow:eRowIndexRangeStart],
                       [self indexPathForRow:eRowIndexRangeEnd]];
    
    if (self.reminder.isLocationReminderValue) {
        NSInteger alwaysShowRow = eRowIndexAlwaysShow;
        if (!self.rangeEnableSwitch.on) {
            // indexPathForRow thinks range cells are already gone
            alwaysShowRow += 2;
        }
        paths = [paths arrayByAddingObject:[self indexPathForRow:alwaysShowRow]];
    }
    
    if (self.rangeEnableSwitch.on) {
        [self insertRowsAtIndexPaths:paths];
    }
    else {
        [self deleteRowsAtIndexPaths:paths];
    }
    
    if (!self.reminder.isLocationReminderValue) {
        // update label to/from "random"
        [self.tableView reloadRowsAtIndexPaths:@[[self indexPathForRow:eRowIndexTimeOrLocation]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (void)constrainEndTime
{
    self.endTimePicker.minimumDate = [self.startTimePicker.date dateByAddingMinutes:1];
    NSDate *endOfDay = [NSDate endOfDayToday];
    self.endTimePicker.maximumDate = [self.startTimePicker.date dateWithTimeFromDate:endOfDay];
}

- (void)toggleTimePickerForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pathsToAdd;
    NSArray *pathsToDelete;
    
    if ([indexPath isEqual:[self indexPathForRow:eRowIndexRangeEnd]]) {
        [self constrainEndTime];
    }
    
    if (self.timePickerPath != nil) {
        if (self.timePickerPath.row == indexPath.row + 1) {
            // hide time picker
            pathsToDelete = @[self.timePickerPath];
            self.timePickerPath = nil;
        }
        else {
            // move time picker
            BOOL before = indexPath.row < self.timePickerPath.row;
            pathsToDelete = @[self.timePickerPath];
            self.timePickerPath = before ? [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section] : indexPath;
            pathsToAdd = @[self.timePickerPath];
        }
    }
    else {
        // show time picker
        self.timePickerPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        pathsToAdd = @[self.timePickerPath];
    }
    
    // Animate the deletions and insertions
    [self.tableView beginUpdates];
    if (pathsToDelete.count)
        [self.tableView deleteRowsAtIndexPaths:pathsToDelete
                              withRowAnimation:UITableViewRowAnimationFade];
    if (pathsToAdd.count)
        [self.tableView insertRowsAtIndexPaths:pathsToAdd
                              withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)validateTimeRange
{
    if ([[self.startTimePicker.date sameTimeToday] isEqualToDate:[NSDate endOfDayToday]]) {
        self.startTimePicker.date = [self.startTimePicker.date dateByAddingMinutes:1];
    }
    
    if ([[self.endTimePicker.date sameTimeToday] isBeforeDate:[self.startTimePicker.date sameTimeToday]]) {
        self.endTimePicker.date = [self.startTimePicker.date dateByAddingMinutes:1];
        [self.tableView reloadRowsAtIndexPaths:@[[self indexPathForRow:eRowIndexRangeEnd]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)timePickerValueChanged:(UIDatePicker *)sender
{
    NSIndexPath *path = nil;
    if ([sender isEqual:self.alarmTimePicker]) {
        path = [self indexPathForRow:eRowIndexTimeOrLocation];
    }
    else if ([sender isEqual:self.startTimePicker]) {
        path = [self indexPathForRow:eRowIndexRangeStart];
        [self validateTimeRange];
    }
    else if ([sender isEqual:self.endTimePicker]) {
        path = [self indexPathForRow:eRowIndexRangeEnd];
    }
    else {
        return;
    }
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)presentDayPicker
{
    OHMReminderDaysViewController *vc = [[OHMReminderDaysViewController alloc] initWithReminder:self.reminder];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentLocationPicker
{
    UIViewController *vc = nil;
    NSArray *locations = [[OHMClient sharedClient] reminderLocations];
    if (locations.count) {
        vc = [[OHMReminderLocationViewController alloc] initWithReminder:self.reminder];
    }
    else {
        vc = [[OHMLocationSearchViewController alloc] init];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)presentReentryPicker
{
    OHMReminderReentryViewController *vc = [[OHMReminderReentryViewController alloc] initWithReminder:self.reminder];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view

- (NSIndexPath *)indexPathForRow:(NSInteger)row
{
    if (!self.reminder.usesTimeRangeValue && row > eRowIndexRangeEnd) {
        row -= 2;
    }
    
    if (self.timePickerPath != nil && self.timePickerPath.row <= row) {
        // adjust for time picker
        row++;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (void)insertRowsAtIndexPaths:(NSArray *)paths
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:paths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)deleteRowsAtIndexPaths:(NSArray *)paths
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:paths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number or rows in section, timeRangeOn: %d", self.rangeEnableSwitch.on);
    NSInteger rowCount = 3; // timeOrLocation, range enable, repeat
    
    if (self.reminder.usesTimeRangeValue) {
        rowCount += 2; // start, end
    }
    
    if (self.reminder.isLocationReminderValue) {
        rowCount++; // minimum reentry
        if (self.reminder.usesTimeRangeValue) {
            rowCount++; // always show
        }
    }
    
    if (self.timePickerPath != nil) {
        rowCount++; // time picker
    }
    
    return rowCount;
}

- (UITableViewCell *)timePickerCellForRow:(NSInteger)row
{
    NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:row - 1 inSection:0];
    
    if ([previousIndex isEqual:[self indexPathForRow:eRowIndexTimeOrLocation]]) {
        return self.alarmTimePickerCell;
    }
    else if ([previousIndex isEqual:[self indexPathForRow:eRowIndexRangeStart]]) {
        return self.startTimePickerCell;
    }
    else if ([previousIndex isEqual:[self indexPathForRow:eRowIndexRangeEnd]]) {
        return self.endTimePickerCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.timePickerPath isEqual:indexPath]) {
        return [self timePickerCellForRow:indexPath.row];
    }
    else {
        // Adjust row for range and time picker if needed
        NSInteger adjustedRow = indexPath.row;
        
        if (!self.reminder.usesTimeRangeValue && adjustedRow > eRowIndexRangeEnable) {
            adjustedRow += 2; // skip range start and end
        }
        
        if (self.timePickerPath && (self.timePickerPath.row < adjustedRow)) {
            adjustedRow--;
        }
        
        NSLog(@"cell for row: %ld, timeRangeOn: %d, adjusted: %ld", indexPath.row, self.rangeEnableSwitch.on, adjustedRow);
        
        return [self cellForRow:adjustedRow];
    }
}

- (UITableViewCell *)cellForRow:(NSInteger)row
{
    UITableViewCell *cell = nil;
    
    switch (row) {
        case eRowIndexTimeOrLocation:
            cell = self.reminder.isLocationReminderValue ? [self locationCell] : [self reminderTimeCell];
            break;
        case eRowIndexRangeEnable:
        {
            cell = [OHMUserInterface cellWithSwitchFromTableView:self.tableView setupBlock:^(UISwitch *sw) {
                [sw addTarget:self action:@selector(timeRangeEnableSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                sw.on = self.reminder.usesTimeRangeValue;
                self.rangeEnableSwitch = sw;
            }];
            cell.textLabel.text = @"Use time range";
            break;
        }
        case eRowIndexRangeStart:
            cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Start time";
            cell.detailTextLabel.text = [OHMUserInterface formattedTime:self.startTimePicker.date];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case eRowIndexRangeEnd:
            cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
            cell.textLabel.text = @"End time";
            cell.detailTextLabel.text = [OHMUserInterface formattedTime:self.endTimePicker.date];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case eRowIndexRepeat:
            cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Repeat";
            cell.detailTextLabel.text = [self.reminder repeatLabelText];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case eRowIndexMinimumReentry:
            cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Ignore consecutive arrivals";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d min", self.reminder.minimumReentryIntervalValue];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case eRowIndexAlwaysShow:
        {
            cell = [OHMUserInterface cellWithSwitchFromTableView:self.tableView setupBlock:^(UISwitch *sw) {
                [sw addTarget:self.reminder action:@selector(toggleAlwaysShow) forControlEvents:UIControlEventValueChanged];
                sw.on = self.reminder.alwaysShowValue;
            }];
            cell.textLabel.text = kAlwaysShowCellTitle;
            cell.detailTextLabel.text = kAlwaysShowCellSubtitle;
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}



- (UITableViewCell *)reminderTimeCell
{
    UITableViewCell *cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
    
    cell.textLabel.text = @"Reminder time";
    if (self.reminder.usesTimeRangeValue) {
        cell.detailTextLabel.text = @"Random";
    }
    else {
        cell.detailTextLabel.text = [OHMUserInterface formattedTime:self.alarmTimePicker.date];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (UITableViewCell *)locationCell
{
    UITableViewCell *cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
    
    cell.textLabel.text = @"Location";
    cell.detailTextLabel.text = self.reminder.reminderLocation ? self.reminder.reminderLocation.name : @"Select";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[self indexPathForRow:eRowIndexRepeat]]) {
        [self presentDayPicker];
    }
    else if (self.reminder.usesTimeRangeValue && ([indexPath isEqual:[self indexPathForRow:eRowIndexRangeStart]]
                                           || [indexPath isEqual:[self indexPathForRow:eRowIndexRangeEnd]]) ) {
        [self toggleTimePickerForIndexPath:indexPath];
    }
    else if (self.reminder.isLocationReminderValue) {
        if ([indexPath isEqual:[self indexPathForRow:eRowIndexTimeOrLocation]]) {
            [self presentLocationPicker];
        }
        else if ([indexPath isEqual:[self indexPathForRow:eRowIndexMinimumReentry]]) {
            [self presentReentryPicker];
        }
    }
    else if ([indexPath isEqual:[self indexPathForRow:eRowIndexTimeOrLocation]] && !self.reminder.usesTimeRangeValue) {
        [self toggleTimePickerForIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.timePickerPath isEqual:indexPath]) {
        return self.alarmTimePicker.frame.size.height;
    }
    else if ([indexPath isEqual:[self indexPathForRow:eRowIndexAlwaysShow]]) {
        return [OHMUserInterface heightForSwitchCellWithTitle:kAlwaysShowCellTitle
                                                     subtitle:kAlwaysShowCellSubtitle
                                                fromTableView:tableView];
    }
    
    return tableView.rowHeight;
}

@end
