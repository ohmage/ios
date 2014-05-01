//
//  OHMReminderViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/30/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderViewController.h"
#import "OHMReminder.h"
#import "OHMUserInterface.h"


static const NSInteger kTimeSectionIndex = 0;
static const NSInteger kLocationSectionIndex = 1;

static const NSInteger kTimeRowIndexEnable = 0;
static const NSInteger kTimeRowIndexAlarm = 1;
static const NSInteger kTimeRowIndexRangeEnable = 2;
static const NSInteger kTimeRowIndexRangeStart = 3;
static const NSInteger kTimeRowIndexRangeEnd = 4;
static const NSInteger kTimeRowIndexRepeat = 5;

static const NSInteger kLocationRowIndexEnable = 0;
static const NSInteger kLocationRowIndexLocation = 1;


@interface OHMReminderViewController ()

@property (nonatomic, strong) OHMReminder *reminder;
@property (nonatomic, strong) UISwitch *timeReminderSwitch;
@property (nonatomic, strong) UISwitch *rangeEnableSwitch;
@property (nonatomic, strong) UISwitch *locationReminderSwitch;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
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
    
    self.navigationItem.title = ([self.reminder.objectID isTemporaryID] ? @"Create Reminder" : @"Edit Reminder");
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonPressed:)];
    saveButton.enabled = NO;
    self.navigationItem.rightBarButtonItem = saveButton;
    self.saveButton = saveButton;
    
    [self setupTimePickers];
}

- (void)setupTimePickers
{
    self.alarmTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        self.alarmTimePicker = dp;
    }];
    
    self.startTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        self.startTimePicker = dp;
    }];
    
    self.endTimePickerCell = [OHMUserInterface cellWithTimePickerFromTableView:self.tableView setupBlock:^(UIDatePicker *dp) {
        self.endTimePicker = dp;
    }];
}

- (void)timeReminderSwitchToggled:(id)sender
{
    self.reminder.isTimeReminderValue = self.timeReminderSwitch.on;
    
    NSMutableArray *paths = [NSMutableArray array];
    
    [paths addObject:[self indexPathForTimeRow:kTimeRowIndexAlarm]];
    [paths addObject:[self indexPathForTimeRow:kTimeRowIndexRangeEnable]];
    [paths addObject:[self indexPathForTimeRepeatRow]];
    
    if (self.rangeEnableSwitch.on) {
        [paths addObject:[self indexPathForTimeRow:kTimeRowIndexRangeStart]];
        [paths addObject:[self indexPathForTimeRow:kTimeRowIndexRangeEnd]];
    }
    if (self.timePickerPath != nil) {
        [paths addObject:self.timePickerPath];
        self.timePickerPath = nil;
    }
    
    if (self.timeReminderSwitch.on) {
        [self insertRowsAtIndexPaths:paths];
    }
    else {
        [self deleteRowsAtIndexPaths:paths];
    }
}

- (void)timeRangeEnableSwitchToggled:(id)sender
{
    self.reminder.usesTimeRangeValue = self.rangeEnableSwitch.on;
    NSArray *paths = @[[self indexPathForTimeRow:kTimeRowIndexRangeStart],
                       [self indexPathForTimeRow:kTimeRowIndexRangeEnd]];
    
    if (self.rangeEnableSwitch.on) {
        [self insertRowsAtIndexPaths:paths];
    }
    else {
        [self deleteRowsAtIndexPaths:paths];
    }
}

- (void)locationReminderSwitchToggled:(id)sender
{
    self.reminder.isLocationReminderValue = self.locationReminderSwitch.on;
    
    NSIndexPath *locationPath = [NSIndexPath indexPathForRow:kLocationRowIndexLocation inSection:kLocationSectionIndex];
    
    if (self.locationReminderSwitch.on) {
        [self insertRowsAtIndexPaths:@[locationPath]];
    }
    else {
        [self deleteRowsAtIndexPaths:@[locationPath]];
    }
}

- (void)toggleTimePickerForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *pathsToAdd;
    NSArray *pathsToDelete;
    
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

- (void)saveButtonPressed:(id)sender
{
    
}

#pragma mark - Table view

- (NSIndexPath *)indexPathForTimeRepeatRow
{
    if (!self.reminder.isTimeReminderValue) return nil;
    
    NSInteger row = [self tableView:self.tableView numberOfRowsInSection:kTimeSectionIndex] - 1;
    return [NSIndexPath indexPathForRow:row inSection:kTimeSectionIndex];
}

- (NSIndexPath *)indexPathForTimeRow:(NSInteger)row
{
    
    if (row == kTimeRowIndexRepeat) {
        return [self indexPathForTimeRepeatRow];
    }
    else if (self.timePickerPath != nil && self.timePickerPath.row <= row) {
        // adjust for time picker
        row++;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:kTimeSectionIndex];
    
//    switch (row) {
//        case kTimeRowIndexEnable:
//            return [NSIndexPath indexPathForRow:kTimeRowIndexEnable inSection:kTimeSectionIndex];
//        case kTimeRowIndexAlarm:
//            return [NSIndexPath indexPathForRow:kTimeRowIndexAlarm inSection:kTimeSectionIndex];
//        case kTimeRowIndexRangeEnable:
//            return [NSIndexPath indexPathForRow:kTimeRowIndexRangeEnable inSection:kTimeSectionIndex];
//        case kTimeRowIndexRangeStart:
//            return [NSIndexPath indexPathForRow:kTimeRowIndexRangeStart inSection:kTimeSectionIndex];
//        case kTimeRowIndexRangeEnd:
//            return [NSIndexPath indexPathForRow:kTimeRowIndexRangeEnd inSection:kTimeSectionIndex];
//        case kTimeRowIndexRepeat:
//            return [self indexPathForTimeRepeatRow];
//        default:
//            return nil;
//    }
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSInteger timeSectionRowCount = 1; // time enable
    switch (section) {
        case kTimeSectionIndex:
            if (self.reminder.isTimeReminderValue) {
                timeSectionRowCount += 3; // alarm, range enable, repeat
                if (self.reminder.usesTimeRangeValue) {
                    timeSectionRowCount += 2; // start, end
                }
                if (self.timePickerPath != nil) {
                    timeSectionRowCount++; // time picker
                }
            }
            return timeSectionRowCount;
        case kLocationSectionIndex:
            return (self.reminder.isLocationReminderValue ? 2 : 1);
            
        default:
            return 0;
    }
}

- (UITableViewCell *)timePickerCellForRow:(NSInteger)row
{
    NSIndexPath *previousIndex = [NSIndexPath indexPathForRow:row - 1 inSection:kTimeSectionIndex];
    
    if ([previousIndex isEqual:[self indexPathForTimeRow:kTimeRowIndexAlarm]]) {
        return self.alarmTimePickerCell;
    }
    else if ([previousIndex isEqual:[self indexPathForTimeRow:kTimeRowIndexRangeStart]]) {
        return self.startTimePickerCell;
    }
    else if ([previousIndex isEqual:[self indexPathForTimeRow:kTimeRowIndexRangeEnd]]) {
        return self.endTimePickerCell;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.timePickerPath isEqual:indexPath]) {
        return [self timePickerCellForRow:indexPath.row];
    }
    else if ([[self indexPathForTimeRepeatRow] isEqual:indexPath]) {
        return [self timeRepeatCell];
    }
    else if (indexPath.section == kTimeSectionIndex) {
        
        // Adjust row for time picker if needed
        NSInteger adjustedRow = indexPath.row;
        if (self.timePickerPath && (self.timePickerPath.row < indexPath.row)) {
            adjustedRow--;
        }
        return [self timeCellForRow:adjustedRow];
    }
    else {
        return [self locationCellForRow:indexPath.row];
    }
}

- (UITableViewCell *)timeRepeatCell
{
    UITableViewCell *cell = [OHMUserInterface cellWithDetailStyleFromTableView:self.tableView];
    cell.textLabel.text = @"Repeat";
    cell.detailTextLabel.text = [self.reminder repeatLabelText];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UITableViewCell *)timeCellForRow:(NSInteger)row
{
    UITableViewCell *cell = nil;
    
    switch (row) {
        case kTimeRowIndexEnable:
        {
            cell = [OHMUserInterface cellWithSwitchFromTableView:self.tableView setupBlock:^(UISwitch *sw) {
                [sw addTarget:self action:@selector(timeReminderSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                self.timeReminderSwitch = sw;
            }];
            cell.textLabel.text = @"Remind me at a time";
            break;
        }
        case kTimeRowIndexAlarm:
            cell = [OHMUserInterface cellWithDefaultStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Alarm";
            break;
        case kTimeRowIndexRangeEnable:
        {
            cell = [OHMUserInterface cellWithSwitchFromTableView:self.tableView setupBlock:^(UISwitch *sw) {
                [sw addTarget:self action:@selector(timeRangeEnableSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                self.rangeEnableSwitch = sw;
            }];
            cell.textLabel.text = @"Use time range";
            break;
        }
        case kTimeRowIndexRangeStart:
            cell = [OHMUserInterface cellWithDefaultStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Start time";
            break;
        case kTimeRowIndexRangeEnd:
            cell = [OHMUserInterface cellWithDefaultStyleFromTableView:self.tableView];
            cell.textLabel.text = @"End time";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell *)locationCellForRow:(NSInteger)row
{
    UITableViewCell *cell = nil;
    
    switch (row) {
        case kLocationRowIndexEnable:
        {
            cell = [OHMUserInterface cellWithSwitchFromTableView:self.tableView setupBlock:^(UISwitch *sw) {
                [sw addTarget:self action:@selector(locationReminderSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                self.locationReminderSwitch = sw;
            }];
            cell.textLabel.text = @"Remind me at a location";
            break;
        }
        case kLocationRowIndexLocation:
            cell = [OHMUserInterface cellWithDefaultStyleFromTableView:self.tableView];
            cell.textLabel.text = @"Location";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[self indexPathForTimeRow:kTimeRowIndexAlarm]]
        || [indexPath isEqual:[self indexPathForTimeRow:kTimeRowIndexRangeStart]]
        || [indexPath isEqual:[self indexPathForTimeRow:kTimeRowIndexRangeEnd]]) {
        [self toggleTimePickerForIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.timePickerPath isEqual:indexPath]) {
        return self.alarmTimePicker.frame.size.height;
    }
    
    return tableView.rowHeight;
}

@end
