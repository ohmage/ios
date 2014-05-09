//
//  NSDate+Ohmage.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "NSDate+Ohmage.h"

@implementation NSDate (Ohmage)

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

@end
