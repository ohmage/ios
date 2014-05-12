#import "_OHMReminder.h"

typedef NS_ENUM(NSUInteger, OHMRepeatDay) {
    OHMRepeatDaySunday = 1,
    OHMRepeatDayMonday = 1 << 1,
    OHMRepeatDayTuesday = 1 << 2,
    OHMRepeatDayWednesday = 1 << 3,
    OHMRepeatDayThursday = 1 << 4,
    OHMRepeatDayFriday = 1 << 5,
    OHMRepeatDaySaturday = 1 << 6,
    
    OHMRepeatDayNever = 0,
    OHMRepeatDayEveryday = 0x7F
};

@interface OHMReminder : _OHMReminder {}

+ (NSString *)fullNameForRepeatDay:(OHMRepeatDay)repeatDay;
+ (NSString *)shortNameForRepeatDay:(OHMRepeatDay)repeatDay;
+ (NSInteger)calendarUnitForRepeatDay:(OHMRepeatDay)repeatDay;

- (NSString *)labelText;
- (NSString *)detailLabelText;
- (NSString *)repeatLabelText;
- (void)toggleRepeatForDay:(OHMRepeatDay)repeatDay;
- (BOOL)repeatDayIsOn:(OHMRepeatDay)repeatDay;

- (void)toggleEnabled;

- (NSDate *)updateFireDate;

@end
