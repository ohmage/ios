//
//  OHMReminderDaysViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseTableViewController.h"

@class OHMReminder;

@interface OHMReminderDaysViewController : OHMBaseTableViewController

- (instancetype)initWithReminder:(OHMReminder *)reminder;

@end
