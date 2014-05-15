//
//  OHMReminderViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/30/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseTableViewController.h"

@interface OHMReminderViewController : OHMBaseTableViewController

@property (nonatomic, strong) OHMReminder *reminder;

- (instancetype)initWithReminder:(OHMReminder *)reminder;

@end
