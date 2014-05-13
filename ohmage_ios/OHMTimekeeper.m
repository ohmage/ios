//
//  OHMTimekeeper.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMTimekeeper.h"
#import "OHMReminder.h"
#import "OHMSurvey.h"

@implementation OHMTimekeeper

+ (instancetype)sharedTimekeeper
{
    static OHMTimekeeper *_sharedTimekeeper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTimekeeper = [[self alloc] initPrivate];
    });
    
    return _sharedTimekeeper;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMTimekeeper sharedTimekeeper]"
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

/**
 *  processFiredLocalNotification
 */
- (void)processFiredLocalNotification:(UILocalNotification *)notification {
    NSString *ohmID = notification.userInfo.reminderID;
    OHMReminder *reminder = [[OHMClient sharedClient] reminderWithOhmID:ohmID];
    
    // todo: fix
    [self cancelAllNotifications];
    return;
    
    // Update the reminder if it's still enabled and designed to repeat.
    if (reminder.enabledValue) {
        if (reminder.weekdaysMaskValue != OHMRepeatDayNever) {
            [self updateNotificationForReminder:reminder];
        }
//        else {
//            // If this was a one-shot reminder, then mark it as being no longer enabled.
//            [self setValue:[NSNumber numberWithBool:NO] forKey:reminderEnabledPropertyName];
//        }
    }
}

/**
 *  cancelAllNotifications
 */
- (void)cancelAllNotifications {
    UIApplication *application = [UIApplication sharedApplication];
    [application cancelAllLocalNotifications];
}

/**
 *  debugPrintAllNotifications
 */
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
        NSLog(@"%@", [NSString stringWithFormat:@"%u. %@, %@", idx + 1, reminderID, [dateFormatter stringFromDate:fireDate]]);
    }];
#endif
}

/**
 *  updateNotificationForReminder
 */
- (void)updateNotificationForReminder:(OHMReminder *)reminder
{
    NSLog(@"update notification for reminder: %@", reminder);
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
        UILocalNotification *notification = [self notificationWithReminder:reminder];
        [application scheduleLocalNotification:notification];
    }
    
    [self debugPrintAllNotifications];
}

/**
 *  notificationWithReminderName
 */
- (UILocalNotification *)notificationWithReminder:(OHMReminder *)reminder
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSString *alertBody = [NSString stringWithFormat:@"Reminder: Take survey '%@'", reminder.survey.surveyName];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo.reminderID = reminder.ohmID;
    
    NSDate *fireDate = [reminder updateFireDate];
    if (!fireDate) {
        NSLog(@"Can't schedule notification for reminder with nil fire date: %@", reminder);
    }

    // Note that we don't take advantage of UILocalNotifications repeatInterval because there's been talk of
    // using repeat frequencies that aren't easily mapped to an NSCalendarUnit (like every three months).
    
    notification.alertBody = alertBody;
    notification.fireDate = fireDate;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = userInfo;
    
    return notification;
}

/**
 *  syncStateOfRemindersWithScheduledLocalNotifications
 */
- (void)syncStateOfRemindersWithScheduledLocalNotifications {
    // We consider the system's state to be the "correct" state with respect to which reminders
    // are enabled and when they are scheduled to fire. This method syncs our local representation
    // of the reminders with the actual outstanding scheduled notifications of our Application.
    
    NSArray *reminders = [[OHMClient sharedClient] reminders];
    for (OHMReminder *reminder in reminders) {
        NSLog(@"Reminder for survey: %@, %@", reminder.survey.surveyName, reminder);
        [self updateNotificationForReminder:reminder];
    }
    
    // This will cycle through all scheduled local notifications and properly set the local
    // "enabled" property for that reminder, thus keeping us in sync with the system.
//    NSArray *scheduledNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
//    for (UILocalNotification *notification in scheduledNotifications) {
//        NSString *notificationReminderName = [notification.userInfo valueForKey:@"notificationReminderName"];
//        NSString *reminderEnabledPropertyName = [self.observerMappings valueForKey:notificationReminderName];
//        
//        // Mark the reminder as being enabled since there's an outstanding notification for it.
//        [self setValue:[NSNumber numberWithBool:YES] forKey:reminderEnabledPropertyName];
//        
//        // Update the Timeslip values to match the outstanding notification's.
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSCalendarUnit units = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
//        NSDateComponents *components = [calendar components:units fromDate:notification.fireDate];
//        
//        Timeslip *timeslip = [self valueForKey:notificationReminderName];
//        timeslip.weekday = [components weekday];
//        timeslip.hour = [components hour];
//        timeslip.minute = [components minute];
//    }
}

@end
