//
//  OHMUserViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMUserViewController.h"
#import "OHMLoginViewController.h"
#import "OHMReminderViewController.h"
#import "OHMUser.h"
#import "OHMReminder.h"
#import "OHMSurvey.h"

static NSInteger const kSettingsSectionIndex = 0;
static NSInteger const kRemindersSectionIndex = 1;

static NSInteger const kSettingsRowCellularData = 0;
//static NSInteger const kSettingsRowSyncNow = 1;
static NSInteger const kSettingsRowClearUserData = 1;
static NSInteger const kSettingsRowCount = 2;

@interface OHMUserViewController ()

@property (nonatomic, strong) OHMUser *user;
@property (nonatomic, strong) NSArray *reminders;

@property (nonatomic, strong) UISwitch *cellularDataSwitch;

@end

@implementation OHMUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"User Info";
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    self.user = [[OHMClient sharedClient] loggedInUser];
    [self setupHeader];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"survey.surveyName" ascending:YES];
    self.reminders = [self.user.reminders sortedArrayUsingDescriptors:@[sort]];
    
//    self.tableView.backgroundColor = [[OHMAppConstants lightOhmageColor] lightColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    self.navigationController.navigationBar.barTintColor = [OHMAppConstants ohmageColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonPressed:(id)sender
{
    [self cancelModalPresentationButtonPressed:sender];
}

- (void)logoutButtonPressed:(id)sender
{
    [[OHMClient sharedClient] logout];
    OHMLoginViewController *vc = [[OHMLoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupHeader
{
    
    CGFloat contentWidth = self.tableView.bounds.size.width - 2 * kUIViewHorizontalMargin;
    CGFloat contentHeight = kUIViewVerticalMargin;
    
    UILabel *nameLabel = [OHMUserInterface headerTitleLabelWithText:self.user.fullName width:contentWidth];
    contentHeight += nameLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UILabel *emailLabel = [OHMUserInterface headerDescriptionLabelWithText:self.user.email width:contentWidth];
    contentHeight += emailLabel.frame.size.height + kUIViewVerticalMargin;
    
    UIButton *button = [OHMUserInterface buttonWithTitle:@"Sign Out"
                                                   color:[OHMAppConstants ohmageColor]
                                                  target:self
                                                  action:@selector(logoutButtonPressed:)
                                                maxWidth:contentWidth];
    contentHeight += button.frame.size.height + kUIViewVerticalMargin;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, contentHeight)];
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:emailLabel];
    [headerView addSubview:button];
    
    [nameLabel centerHorizontallyInView:headerView];
    [emailLabel centerHorizontallyInView:headerView];
    [button centerHorizontallyInView:headerView];
    
    [nameLabel constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [emailLabel positionBelowElement:nameLabel margin:kUIViewSmallTextMargin];
    [button positionBelowElement:emailLabel margin:kUIViewVerticalMargin];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)confirmationAlertDidConfirm:(UIAlertView *)alert
{
    [[OHMClient sharedClient] clearUserData];
    self.reminders = nil;
    [self.tableView reloadData];
}

- (void)cellularDataSwitchToggled:(id)sender
{
    self.user.useCellularDataValue = self.cellularDataSwitch.on;
    [[OHMClient sharedClient] saveClientState];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kSettingsSectionIndex:
            return kSettingsRowCount;
        case kRemindersSectionIndex:
            return self.reminders.count;
            
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == kSettingsSectionIndex) {
        switch (indexPath.row) {
            case kSettingsRowCellularData:
            {
                cell = [OHMUserInterface cellWithSwitchFromTableView:tableView setupBlock:^(UISwitch *sw) {
                    sw.on = self.user.useCellularDataValue;
                    [sw addTarget:self action:@selector(cellularDataSwitchToggled:) forControlEvents:UIControlEventValueChanged];
                    self.cellularDataSwitch = sw;
                }];
                cell.textLabel.text = @"Use cellular data";
                break;
            }
//            case kSettingsRowSyncNow:
//                cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
//                cell.textLabel.text = @"Sync data";
////                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                break;
            case kSettingsRowClearUserData:
                cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
                cell.textLabel.text = @"Clear user data";
                //                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == kRemindersSectionIndex) {
        OHMReminder *reminder = self.reminders[indexPath.row];
        cell = [OHMUserInterface cellWithSwitchFromTableView:tableView setupBlock:^(UISwitch *sw) {
            sw.on = reminder.enabledValue;
            [sw addTarget:reminder action:@selector(toggleEnabled) forControlEvents:UIControlEventValueChanged];
        }];
        cell.textLabel.text = reminder.survey.surveyName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [reminder labelText], [reminder detailLabelText]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kRemindersSectionIndex) {
        OHMReminder *reminder = self.reminders[indexPath.row];
        NSString *title = reminder.survey.surveyName;
        NSString *subtitle = [NSString stringWithFormat:@"%@ %@", [reminder labelText], [reminder detailLabelText]];
        return [OHMUserInterface heightForSwitchCellWithTitle:title subtitle:subtitle fromTableView:tableView];
    }
//    else if (indexPath.section == kSettingsSectionIndex && indexPath.row == kSettingsRowCellularData) {
//        
//    }
    else {
        return tableView.rowHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kSettingsSectionIndex && indexPath.row == kSettingsRowClearUserData) {
        [self presentConfirmationAlertWithTitle:@"Clear user data?" message:@"Are you sure you want to clear all data for this user? This action cannot be undone." confirmTitle:@"Clear data"];
    }
    else if (indexPath.section == kRemindersSectionIndex) {
        OHMReminder *reminder = self.reminders[indexPath.row];
        OHMReminderViewController *vc = [[OHMReminderViewController alloc] initWithReminder:reminder];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kSettingsSectionIndex:
            return @"";
        case kRemindersSectionIndex:
            return (self.reminders.count > 0 ? @"Reminders" : nil);
            
        default:
            return nil;
    }
}


@end
