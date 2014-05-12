//
//  NSDate+Ohmage.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "NSDate+Ohmage.h"

#define SECONDS_PER_MINUTE 60
#define SECONDS_PER_HOUR (SECONDS_PER_MINUTE * 60)
#define SECONDS_PER_DAY (SECONDS_PER_HOUR * 24)

@implementation NSDate (Ohmage)


+ (NSDate *)randomTimeTodayBetweenStartTime:(NSDate *)startTime endTime:(NSDate *)endTime
{
    NSDate *startTimeToday = [startTime sameTimeToday];
    NSTimeInterval interval = [endTime timeIntervalSinceDate:startTime];
    if (interval == 0) {
        return startTimeToday;
    }
    else if (interval < 0) {
        // if interval spans midnight
        interval += SECONDS_PER_DAY;
    }
    
    NSInteger intervalMinutes = interval / SECONDS_PER_MINUTE;
    NSInteger randomMinutes = arc4random() % intervalMinutes;
    NSTimeInterval randomInterval = randomMinutes * SECONDS_PER_MINUTE;
    
    return [NSDate dateWithTimeInterval:randomInterval sinceDate:startTimeToday];
}

+ (NSDateFormatter *)ISO8601Formatter
{
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [dateFormatter setLocale:enUSPOSIXLocale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    }
    return dateFormatter;
}

- (NSString *)ISO8601String
{
    return [[NSDate ISO8601Formatter] stringFromDate:self];
}


/**
 *  dateByAddingMonths
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months {
    return [self dateByAddingMonths:months weeks:0 weekdays:0 days:0 hours:0 minutes:0];
}

/**
 *  dateByAddingWeeks
 */
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    return [self dateByAddingMonths:0 weeks:weeks weekdays:0 days:0 hours:0 minutes:0];
}

/**
 *  dateByAddingWeekdays
 */
- (NSDate *)dateByAddingWeekdays:(NSInteger)weekdays {
    return [self dateByAddingMonths:0 weeks:0 weekdays:weekdays days:0 hours:0 minutes:0];
}

/**
 *  dateByAddingDays
 */
- (NSDate *)dateByAddingDays:(NSInteger)days{
    return [self dateByAddingMonths:0 weeks:0 weekdays:0 days:days hours:0 minutes:0];
}

/**
 *  dateByAddingHours
 */
- (NSDate *)dateByAddingHours:(NSInteger)hours{
    return [self dateByAddingMonths:0 weeks:0 weekdays:0 days:0 hours:hours minutes:0];
}

/**
 *  dateByAddingMinutes
 */
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes{
    return [self dateByAddingMonths:0 weeks:0 weekdays:0 days:0 hours:0 minutes:minutes];
}

/**
 *  dateByAddingMonths:days:hours:minutes
 */
- (NSDate *)dateByAddingMonths:(NSInteger)months
                         weeks:(NSInteger)weeks
                      weekdays:(NSInteger)weekdays
                          days:(NSInteger)days
                         hours:(NSInteger)hours
                       minutes:(NSInteger)minutes {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setMonth:months];
    [components setWeek:weeks];
    [components setWeekday:weekdays];
    [components setDay:days];
    [components setHour:hours];
    [components setMinute:minutes];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateWithTimeFromDate:(NSDate *)timeDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger dateFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSUInteger timeFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:dateFlags fromDate:self];
    NSDateComponents *timeComponents = [calendar components:timeFlags fromDate:timeDate];
    dateComponents.hour = timeComponents.hour;
    dateComponents.minute = timeComponents.minute;
    
    return [calendar dateFromComponents:dateComponents];
}

- (NSDate *)sameTimeToday
{
    return [[NSDate date] dateWithTimeFromDate:self];
}

- (NSInteger)weekdayComponent
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSLog(@"day compenent: %ld, date: %@, components: %@", (long)components.day, self, components);
    return components.weekday;
}

/**
 *  isBeforeDate
 */
- (BOOL)isBeforeDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedAscending);
}

/**
 *  isAfterDate
 */
- (BOOL)isAfterDate:(NSDate *)date {
    return ([self compare:date] == NSOrderedDescending);
}

/**
 *  isToday
 */
- (BOOL)isToday {
    return [self isEqualToDayOfDate:[NSDate date]];
}

/**
 *  isEqualToDayOfDate
 */
- (BOOL)isEqualToDayOfDate:(NSDate *)date {
    NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *theirDateComponents = [calendar components:flags fromDate:date];
    NSDateComponents *ourDateComponents = [calendar components:flags fromDate:self];
    
    NSDate *theirDateWithouTime = [calendar dateFromComponents:theirDateComponents];
    NSDate *ourDateWithoutTime = [calendar dateFromComponents:ourDateComponents];
    
    return [ourDateWithoutTime isEqualToDate:theirDateWithouTime];
}


@end
