// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMReminderLocation.h instead.

@import CoreData;

extern const struct OHMReminderLocationAttributes {
	__unsafe_unretained NSString *hasCustomName;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *radius;
	__unsafe_unretained NSString *streetAddress;
	__unsafe_unretained NSString *uuid;
} OHMReminderLocationAttributes;

extern const struct OHMReminderLocationRelationships {
	__unsafe_unretained NSString *reminders;
	__unsafe_unretained NSString *user;
} OHMReminderLocationRelationships;

@class OHMReminder;
@class OHMUser;

@interface OHMReminderLocationID : NSManagedObjectID {}
@end

@interface _OHMReminderLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) OHMReminderLocationID* objectID;

@property (nonatomic, strong) NSNumber* hasCustomName;

@property (atomic) BOOL hasCustomNameValue;
- (BOOL)hasCustomNameValue;
- (void)setHasCustomNameValue:(BOOL)value_;

//- (BOOL)validateHasCustomName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitude;

@property (atomic) double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* radius;

@property (atomic) float radiusValue;
- (float)radiusValue;
- (void)setRadiusValue:(float)value_;

//- (BOOL)validateRadius:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* streetAddress;

//- (BOOL)validateStreetAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *reminders;

- (NSMutableSet*)remindersSet;

@property (nonatomic, strong) OHMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _OHMReminderLocation (RemindersCoreDataGeneratedAccessors)
- (void)addReminders:(NSSet*)value_;
- (void)removeReminders:(NSSet*)value_;
- (void)addRemindersObject:(OHMReminder*)value_;
- (void)removeRemindersObject:(OHMReminder*)value_;

@end

@interface _OHMReminderLocation (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveHasCustomName;
- (void)setPrimitiveHasCustomName:(NSNumber*)value;

- (BOOL)primitiveHasCustomNameValue;
- (void)setPrimitiveHasCustomNameValue:(BOOL)value_;

- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveRadius;
- (void)setPrimitiveRadius:(NSNumber*)value;

- (float)primitiveRadiusValue;
- (void)setPrimitiveRadiusValue:(float)value_;

- (NSString*)primitiveStreetAddress;
- (void)setPrimitiveStreetAddress:(NSString*)value;

- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;

- (NSMutableSet*)primitiveReminders;
- (void)setPrimitiveReminders:(NSMutableSet*)value;

- (OHMUser*)primitiveUser;
- (void)setPrimitiveUser:(OHMUser*)value;

@end
