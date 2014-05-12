//
//  OHMTimekeeper.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMTimekeeper : NSObject

+ (instancetype)sharedTimekeeper;

- (void)updateNotificationForReminder:(OHMReminder *)reminder;
- (void)processFiredLocalNotification:(UILocalNotification *)notification;
- (void)cancelAllNotifications;
- (void)syncStateOfRemindersWithScheduledLocalNotifications;
- (void)debugPrintAllNotifications;

@end
