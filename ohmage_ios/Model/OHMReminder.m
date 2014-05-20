#import "OHMReminder.h"
#import "OHMUserInterface.h"
#import "OHMReminderLocation.h"
#import "OHMReminderManager.h"


@interface OHMReminder ()

// Private interface goes here.

@end


@implementation OHMReminder

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.ohmID = key;
    self.minimumReentryIntervalValue = 120;
}

- (NSString *)labelText
{
    if (self.isLocationReminderValue) {
        return [NSString stringWithFormat:@"Location: %@", self.reminderLocation.name];
    }
    else if (self.usesTimeRangeValue) {
        return [NSString stringWithFormat:@"%@ - %@", [OHMUserInterface formattedTime:self.startTime],
                                                      [OHMUserInterface formattedTime:self.endTime]];
    }
    else if (self.specificTime != nil) {
        return [OHMUserInterface formattedTime:self.specificTime];
    }
    else {
        return @"Reminder";
    }
}

- (NSString *)detailLabelText
{
    if (self.weekdaysMaskValue == OHMRepeatDayNever) {
        return @"No repeat";
    }
    else {
        return [self repeatLabelText];
    }
}

- (NSString *)repeatLabelText
{
    int16_t mask = self.weekdaysMaskValue;
    if (mask == OHMRepeatDayEveryday || mask == OHMRepeatDayNever) {
        return [OHMReminder fullNameForRepeatDay:mask];
    }
    
    NSArray *repeatDays = [self repeatDays];
    
    if (repeatDays.count == 1) {
        OHMRepeatDay day = [(NSNumber *)repeatDays.firstObject unsignedIntegerValue];
        return [OHMReminder fullNameForRepeatDay:day];
    }
    
    NSMutableString * text = [NSMutableString string];
    NSString *comma = @"";
    
    for (NSNumber *day in repeatDays) {
        [text appendFormat:@"%@%@", comma, [OHMReminder shortNameForRepeatDay:day.unsignedIntegerValue]];
        comma = @", ";
    }
    
    if (self.isLocationReminderValue && self.usesTimeRangeValue) {
        [text appendFormat:@", %@ - %@", [OHMUserInterface formattedTime:self.startTime],
                                       [OHMUserInterface formattedTime:self.endTime]];
    }
    
    return text;
}

- (NSArray *)repeatDays
{
    NSMutableArray *days = [NSMutableArray array];
    for (int16_t day = 1; day < OHMRepeatDayEveryday; day <<= 1) {
        if ([self repeatDayIsOn:day]) {
            [days addObject:@(day)];
        }
    }
    return days;
}

- (void)toggleRepeatForDay:(OHMRepeatDay)repeatDay
{
    self.weekdaysMaskValue ^= repeatDay;
}

- (BOOL)repeatDayIsOn:(OHMRepeatDay)repeatDay
{
    if (self.weekdaysMaskValue == OHMRepeatDayEveryday)
        return YES;
    else
        return (self.weekdaysMaskValue & repeatDay);
}

- (void)toggleAlwaysShow
{
    self.alwaysShowValue = !self.alwaysShowValue;
}

- (void)toggleEnabled
{
    self.enabledValue = !self.enabledValue;
    [[OHMReminderManager sharedReminderManager] updateScheduleForReminder:self];
}

- (OHMRepeatDay)nextRepeatDayAfterDay:(OHMRepeatDay)repeatDay
{
    NSArray *days = [self repeatDays];
    for (NSNumber *dayNumber in days) {
        OHMRepeatDay day = dayNumber.unsignedIntegerValue;
        if (day >= repeatDay) return day;
    }
    return [(NSNumber *)days.firstObject unsignedIntegerValue];
}

- (BOOL)shouldFireLocationNotification
{
    NSDate *now = [NSDate date];
    NSInteger dayCalUnit = now.weekdayComponent;
    OHMRepeatDay repeatDay = [OHMReminder repeatDayForCalendarUnit:dayCalUnit];
    
    BOOL canFireToday = NO;
    NSArray *days = [self repeatDays];
    for (NSNumber *dayNumber in days) {
        OHMRepeatDay day = dayNumber.unsignedIntegerValue;
        if (day == repeatDay) {
            canFireToday = YES;
            break;
        }
    }
    
    if (!canFireToday) return NO; // not today
    else if ([self.startTime isAfterDate:now]) return NO; // too early
    else if ([self.endTime isBeforeDate:now]) return NO; // too late
    else if (self.lastFireDate
             && [[self.lastFireDate dateByAddingMinutes:self.minimumReentryIntervalValue]
                 isAfterDate:now])
    {
        return NO; //too soon
    }
    else {
        return YES; //just right
    }
}

- (NSUInteger)daysUntilNextFireDate
{
    NSDate *now = [NSDate date];
    BOOL canFireToday = NO;
    if (![self.lastFireDate isEqualToDayOfDate:now]) {
        if (self.usesTimeRangeValue) {
            canFireToday = [[self.endTime sameTimeToday] isAfterDate:now];
        }
        else {
            canFireToday = [[self.specificTime sameTimeToday] isAfterDate:now];
        }
    }
    
    if (self.weekdaysMaskValue == OHMRepeatDayNever) {
        return canFireToday ? 0 : 1;
    }
    
    NSInteger dayCalUnit = now.weekdayComponent;
    if (!canFireToday) dayCalUnit++;
    if (dayCalUnit > 7) dayCalUnit -= 7;
    OHMRepeatDay repeatDay = [OHMReminder repeatDayForCalendarUnit:dayCalUnit];
    
    OHMRepeatDay nextDay = [self nextRepeatDayAfterDay:repeatDay];
    NSInteger nextDayCalUnit = [OHMReminder calendarUnitForRepeatDay:nextDay];
    
    NSInteger interval = nextDayCalUnit - now.weekdayComponent;
    if (interval < 0) interval += 7;
    
    return interval;
}

- (void)updateNextFireDate
{
    if (self.enabledValue) {
//        if (self.isLocationReminderValue) {
//            return [NSDate date]; // don't set nextFireDate, but return date for scheduling
//        }
//        else if ([[NSDate date] isBeforeDate:self.nextFireDate]) {
//            return self.nextFireDate; // reminder hasn't fired yet
//        }
        
        NSDate *fireTimeToday = nil;
        
        if (self.isLocationReminderValue) {
            if (self.usesTimeRangeValue && self.alwaysShowValue) {
                fireTimeToday = self.endTime.sameTimeToday;
            }
            else {
                self.nextFireDate = nil;
            }
        }
        else if (self.usesTimeRangeValue) {
            fireTimeToday = [NSDate randomTimeTodayBetweenStartTime:self.startTime endTime:self.endTime];
        }
        else {
            fireTimeToday = self.specificTime.sameTimeToday;
        }
        self.nextFireDate = [fireTimeToday dateByAddingDays:[self daysUntilNextFireDate]];
    }
    else {
        self.nextFireDate = nil;
    }
    
    NSLog(@"updated fire date: %@, %@", [OHMUserInterface formattedDate:self.nextFireDate], [OHMUserInterface formattedTime:self.nextFireDate]);
//    return self.nextFireDate;
}


#pragma mark - Class Methods

+ (NSString *)fullNameForRepeatDay:(OHMRepeatDay)repeatDay
{
    switch (repeatDay) {
        case OHMRepeatDaySunday:
            return @"Sunday";
        case OHMRepeatDayMonday:
            return @"Monday";
        case OHMRepeatDayTuesday:
            return @"Tuesday";
        case OHMRepeatDayWednesday:
            return @"Wednesday";
        case OHMRepeatDayThursday:
            return @"Thursday";
        case OHMRepeatDayFriday:
            return @"Friday";
        case OHMRepeatDaySaturday:
            return @"Saturday";
        case OHMRepeatDayNever:
            return @"Never";
        case OHMRepeatDayEveryday:
            return @"Everyday";
            
        default:
            return nil;
    }
}

+ (NSString *)mediumNameForRepeatDay:(OHMRepeatDay)repeatDay
{
    switch (repeatDay) {
        case OHMRepeatDaySunday:
            return @"Sun";
        case OHMRepeatDayMonday:
            return @"Mon";
        case OHMRepeatDayTuesday:
            return @"Tue";
        case OHMRepeatDayWednesday:
            return @"Wed";
        case OHMRepeatDayThursday:
            return @"Thu";
        case OHMRepeatDayFriday:
            return @"Fri";
        case OHMRepeatDaySaturday:
            return @"Sat";
            
        default:
            return nil;
    }
}

+ (NSString *)shortNameForRepeatDay:(OHMRepeatDay)repeatDay
{
    switch (repeatDay) {
        case OHMRepeatDaySunday:
            return @"Su";
        case OHMRepeatDayMonday:
            return @"M";
        case OHMRepeatDayTuesday:
            return @"T";
        case OHMRepeatDayWednesday:
            return @"W";
        case OHMRepeatDayThursday:
            return @"Th";
        case OHMRepeatDayFriday:
            return @"F";
        case OHMRepeatDaySaturday:
            return @"Sa";
            
        default:
            return nil;
    }
}

+ (NSInteger)calendarUnitForRepeatDay:(OHMRepeatDay)repeatDay
{
    switch (repeatDay) {
        case OHMRepeatDaySunday:
            return 1;
        case OHMRepeatDayMonday:
            return 2;
        case OHMRepeatDayTuesday:
            return 3;
        case OHMRepeatDayWednesday:
            return 4;
        case OHMRepeatDayThursday:
            return 5;
        case OHMRepeatDayFriday:
            return 6;
        case OHMRepeatDaySaturday:
            return 7;
            
        default:
            return 0;
    }
}

+ (OHMRepeatDay)repeatDayForCalendarUnit:(NSInteger)calendarUnit
{
    switch (calendarUnit) {
        case 1:
            return OHMRepeatDaySunday;
        case 2:
            return OHMRepeatDayMonday;
        case 3:
            return OHMRepeatDayTuesday;
        case 4:
            return OHMRepeatDayWednesday;
        case 5:
            return OHMRepeatDayThursday;
        case 6:
            return OHMRepeatDayFriday;
        case 7:
            return OHMRepeatDaySaturday;
            
        default:
            return 0;
    }
}

@end
