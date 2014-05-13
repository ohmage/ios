// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMReminder.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMReminderAttributes {
	__unsafe_unretained NSString *alwaysShow;
	__unsafe_unretained NSString *enabled;
	__unsafe_unretained NSString *endTime;
	__unsafe_unretained NSString *fireDate;
	__unsafe_unretained NSString *isLocationReminder;
	__unsafe_unretained NSString *minimumReentryInterval;
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *specificTime;
	__unsafe_unretained NSString *startTime;
	__unsafe_unretained NSString *usesTimeRange;
	__unsafe_unretained NSString *weekdaysMask;
} OHMReminderAttributes;

extern const struct OHMReminderRelationships {
	__unsafe_unretained NSString *reminderLocation;
	__unsafe_unretained NSString *survey;
	__unsafe_unretained NSString *user;
} OHMReminderRelationships;

extern const struct OHMReminderFetchedProperties {
} OHMReminderFetchedProperties;

@class OHMReminderLocation;
@class OHMSurvey;
@class OHMUser;













@interface OHMReminderID : NSManagedObjectID {}
@end

@interface _OHMReminder : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMReminderID*)objectID;





@property (nonatomic, strong) NSNumber* alwaysShow;



@property BOOL alwaysShowValue;
- (BOOL)alwaysShowValue;
- (void)setAlwaysShowValue:(BOOL)value_;

//- (BOOL)validateAlwaysShow:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* enabled;



@property BOOL enabledValue;
- (BOOL)enabledValue;
- (void)setEnabledValue:(BOOL)value_;

//- (BOOL)validateEnabled:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endTime;



//- (BOOL)validateEndTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* fireDate;



//- (BOOL)validateFireDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isLocationReminder;



@property BOOL isLocationReminderValue;
- (BOOL)isLocationReminderValue;
- (void)setIsLocationReminderValue:(BOOL)value_;

//- (BOOL)validateIsLocationReminder:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* minimumReentryInterval;



@property int32_t minimumReentryIntervalValue;
- (int32_t)minimumReentryIntervalValue;
- (void)setMinimumReentryIntervalValue:(int32_t)value_;

//- (BOOL)validateMinimumReentryInterval:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* specificTime;



//- (BOOL)validateSpecificTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startTime;



//- (BOOL)validateStartTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* usesTimeRange;



@property BOOL usesTimeRangeValue;
- (BOOL)usesTimeRangeValue;
- (void)setUsesTimeRangeValue:(BOOL)value_;

//- (BOOL)validateUsesTimeRange:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* weekdaysMask;



@property int16_t weekdaysMaskValue;
- (int16_t)weekdaysMaskValue;
- (void)setWeekdaysMaskValue:(int16_t)value_;

//- (BOOL)validateWeekdaysMask:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMReminderLocation *reminderLocation;

//- (BOOL)validateReminderLocation:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMReminder (CoreDataGeneratedAccessors)

@end

@interface _OHMReminder (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAlwaysShow;
- (void)setPrimitiveAlwaysShow:(NSNumber*)value;

- (BOOL)primitiveAlwaysShowValue;
- (void)setPrimitiveAlwaysShowValue:(BOOL)value_;




- (NSNumber*)primitiveEnabled;
- (void)setPrimitiveEnabled:(NSNumber*)value;

- (BOOL)primitiveEnabledValue;
- (void)setPrimitiveEnabledValue:(BOOL)value_;




- (NSDate*)primitiveEndTime;
- (void)setPrimitiveEndTime:(NSDate*)value;




- (NSDate*)primitiveFireDate;
- (void)setPrimitiveFireDate:(NSDate*)value;




- (NSNumber*)primitiveIsLocationReminder;
- (void)setPrimitiveIsLocationReminder:(NSNumber*)value;

- (BOOL)primitiveIsLocationReminderValue;
- (void)setPrimitiveIsLocationReminderValue:(BOOL)value_;




- (NSNumber*)primitiveMinimumReentryInterval;
- (void)setPrimitiveMinimumReentryInterval:(NSNumber*)value;

- (int32_t)primitiveMinimumReentryIntervalValue;
- (void)setPrimitiveMinimumReentryIntervalValue:(int32_t)value_;




- (NSString*)primitiveOhmID;
- (void)setPrimitiveOhmID:(NSString*)value;




- (NSDate*)primitiveSpecificTime;
- (void)setPrimitiveSpecificTime:(NSDate*)value;




- (NSDate*)primitiveStartTime;
- (void)setPrimitiveStartTime:(NSDate*)value;




- (NSNumber*)primitiveUsesTimeRange;
- (void)setPrimitiveUsesTimeRange:(NSNumber*)value;

- (BOOL)primitiveUsesTimeRangeValue;
- (void)setPrimitiveUsesTimeRangeValue:(BOOL)value_;




- (NSNumber*)primitiveWeekdaysMask;
- (void)setPrimitiveWeekdaysMask:(NSNumber*)value;

- (int16_t)primitiveWeekdaysMaskValue;
- (void)setPrimitiveWeekdaysMaskValue:(int16_t)value_;





- (OHMReminderLocation*)primitiveReminderLocation;
- (void)setPrimitiveReminderLocation:(OHMReminderLocation*)value;



- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;



- (OHMUser*)primitiveUser;
- (void)setPrimitiveUser:(OHMUser*)value;


@end
