#import "OHMReminder.h"
#import "OHMUserInterface.h"


@interface OHMReminder ()

// Private interface goes here.

@end


@implementation OHMReminder

- (NSString *)labelText
{
    NSString *text = @"";
    if (self.isLocationReminderValue) {
        text = @"Location: ";
    }
    
    if (self.usesTimeRangeValue) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@ - %@",
                                              [OHMUserInterface formattedTime:self.startTime],
                                              [OHMUserInterface formattedTime:self.endTime]]];
    }
    else {
        text = [text stringByAppendingString:[OHMUserInterface formattedTime:self.specificTime]];
    }
    
    return text;
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
    
    NSMutableString * text = [NSMutableString string];
    NSString *singleDayName = nil;
    NSString *comma = @"";
    int dayCount = 0;
    
    for (int16_t day = 1; day <= OHMRepeatDayEveryday; day <<= 1) {
        if ([self repeatDayIsOn:day]) {
            
            [text appendFormat:@"%@%@", comma, [OHMReminder shortNameForRepeatDay:day]];
            comma = @", ";
            
            dayCount++;
            if (dayCount == 1) {
                singleDayName = [OHMReminder fullNameForRepeatDay:day];
            }
        }
    }
    
    // if only one day is selected, use full name
    if (dayCount == 1) {
        return singleDayName;
    }
    else {
        return text;
    }
}

- (void)toggleRepeatForDay:(OHMRepeatDay)repeatDay
{
    self.weekdaysMaskValue ^= repeatDay;
}

- (BOOL)repeatDayIsOn:(OHMRepeatDay)repeatDay
{
    return (self.weekdaysMaskValue & repeatDay);
}

- (void)toggleEnabled
{
    self.enabledValue = !self.enabledValue;
}

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

+ (NSString *)shortNameForRepeatDay:(OHMRepeatDay)repeatDay
{
    switch (repeatDay) {
        case OHMRepeatDaySunday:
            return @"Su";
        case OHMRepeatDayMonday:
            return @"Mo";
        case OHMRepeatDayTuesday:
            return @"Tu";
        case OHMRepeatDayWednesday:
            return @"We";
        case OHMRepeatDayThursday:
            return @"Th";
        case OHMRepeatDayFriday:
            return @"Fr";
        case OHMRepeatDaySaturday:
            return @"Sa";
            
        default:
            return nil;
    }
}

@end
