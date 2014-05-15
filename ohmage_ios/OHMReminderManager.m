//
//  OHMReminderManager.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderManager.h"
#import "OHMReminder.h"
#import "OHMLocationManager.h"
#import "OHMReminderLocation.h"
#import "OHMSurvey.h"

@implementation OHMReminderManager

+ (instancetype)sharedReminderManager
{
    static OHMReminderManager *_sharedReminderManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReminderManager = [[self alloc] initPrivate];
    });
    
    return _sharedReminderManager;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMReminderManager sharedReminderManager]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        [self debugPrintAllNotifications];
    }
    return self;
}

- (void)updateScheduleForReminder:(OHMReminder *)reminder
{
    if (reminder.isLocationReminderValue) {
        [self updateLocationReminder:reminder];
    }
    else {
        [self updateTimeReminder:reminder];
    }
}

- (void)updateLocationReminder:(OHMReminder *)reminder
{
    NSLog(@"update location reminder: %@", reminder);
    if (reminder.enabledValue) {
        [[OHMLocationManager sharedLocationManager].locationManager startMonitoringForRegion:reminder.reminderLocation.region];
    }
    else {
        [[OHMLocationManager sharedLocationManager].locationManager stopMonitoringForRegion:reminder.reminderLocation.region];
    }
}

- (void)updateTimeReminder:(OHMReminder *)reminder
{
    NSLog(@"update time reminder: %@", reminder);
    UIApplication *application = [UIApplication sharedApplication];
    NSArray *existingNotifications = application.scheduledLocalNotifications;
    
    // Cancel any notifications that might be associated with this reminder.
    for (UILocalNotification *notification in existingNotifications) {
        NSString *reminderID = notification.userInfo.reminderID;
        
        if ([reminderID isEqualToString:reminder.ohmID]) {
            [application cancelLocalNotification:notification];
        }
    }
    
    // Determine if the reminder is enabled and if so schedule a local notification for it.
    if (reminder.enabledValue) {
        [self scheduleNotificationForReminder:reminder];
    }
    
    [self debugPrintAllNotifications];
}

- (void)scheduleNotificationForReminder:(OHMReminder *)reminder
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSString *alertBody = [NSString stringWithFormat:@"Reminder: Take survey '%@'", reminder.survey.surveyName];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo.reminderID = reminder.ohmID;
    
    NSDate *fireDate = [reminder updateNextFireDate];
    if (!fireDate) {
        NSLog(@"Can't schedule notification for reminder with nil fire date: %@", reminder);
    }
    
    notification.alertBody = alertBody;
    notification.fireDate = fireDate;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = userInfo;
    
    NSLog(@"scheduling notification: %@ for reminder: %@", notification, reminder);
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)processFiredLocalNotification:(UILocalNotification *)notification {
    NSString *ohmID = notification.userInfo.reminderID;
    OHMReminder *reminder = [[OHMClient sharedClient] reminderWithOhmID:ohmID];
    reminder.lastFireDate = notification.fireDate;
    reminder.survey.isDueValue = YES;
    
    if (reminder.weekdaysMaskValue == OHMRepeatDayNever) {
        reminder.enabledValue = NO;
    }
    
    [self updateScheduleForReminder:reminder];
}

- (void)updateRemindersForFiredNotifications
{
    NSArray *timeReminders = [[OHMClient sharedClient] timeReminders];
    for (OHMReminder *reminder in timeReminders) {
        if (reminder.nextFireDate != nil && [reminder.nextFireDate isBeforeDate:[NSDate date]]) {
            [self updateScheduleForReminder:reminder];
        }
    }
    [self debugPrintAllNotifications];
}



- (void)debugPrintAllNotifications {
#ifdef DEBUG
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    dateFormatter.timeStyle = NSDateFormatterFullStyle;
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"There are %lu local notifications scheduled.", (unsigned long)[notifications count]);
    
    [notifications enumerateObjectsUsingBlock:^(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSString *reminderID = notification.userInfo.reminderID;
        NSDate *fireDate = notification.fireDate;
        NSLog(@"%@", [NSString stringWithFormat:@"%lu. %@, %@", idx + 1, reminderID, [dateFormatter stringFromDate:fireDate]]);
    }];
#endif
}

@end
