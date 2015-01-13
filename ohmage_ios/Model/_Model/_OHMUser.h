// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.h instead.

@import CoreData;

extern const struct OHMUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *fullName;
	__unsafe_unretained NSString *useCellularData;
} OHMUserAttributes;

extern const struct OHMUserRelationships {
	__unsafe_unretained NSString *reminderLocations;
	__unsafe_unretained NSString *reminders;
	__unsafe_unretained NSString *surveyResponses;
	__unsafe_unretained NSString *surveys;
} OHMUserRelationships;

@class OHMReminderLocation;
@class OHMReminder;
@class OHMSurveyResponse;
@class OHMSurvey;

@interface OHMUserID : NSManagedObjectID {}
@end

@interface _OHMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) OHMUserID* objectID;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fullName;

//- (BOOL)validateFullName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* useCellularData;

@property (atomic) BOOL useCellularDataValue;
- (BOOL)useCellularDataValue;
- (void)setUseCellularDataValue:(BOOL)value_;

//- (BOOL)validateUseCellularData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *reminderLocations;

- (NSMutableSet*)reminderLocationsSet;

@property (nonatomic, strong) NSSet *reminders;

- (NSMutableSet*)remindersSet;

@property (nonatomic, strong) NSSet *surveyResponses;

- (NSMutableSet*)surveyResponsesSet;

@property (nonatomic, strong) NSSet *surveys;

- (NSMutableSet*)surveysSet;

@end

@interface _OHMUser (ReminderLocationsCoreDataGeneratedAccessors)
- (void)addReminderLocations:(NSSet*)value_;
- (void)removeReminderLocations:(NSSet*)value_;
- (void)addReminderLocationsObject:(OHMReminderLocation*)value_;
- (void)removeReminderLocationsObject:(OHMReminderLocation*)value_;

@end

@interface _OHMUser (RemindersCoreDataGeneratedAccessors)
- (void)addReminders:(NSSet*)value_;
- (void)removeReminders:(NSSet*)value_;
- (void)addRemindersObject:(OHMReminder*)value_;
- (void)removeRemindersObject:(OHMReminder*)value_;

@end

@interface _OHMUser (SurveyResponsesCoreDataGeneratedAccessors)
- (void)addSurveyResponses:(NSSet*)value_;
- (void)removeSurveyResponses:(NSSet*)value_;
- (void)addSurveyResponsesObject:(OHMSurveyResponse*)value_;
- (void)removeSurveyResponsesObject:(OHMSurveyResponse*)value_;

@end

@interface _OHMUser (SurveysCoreDataGeneratedAccessors)
- (void)addSurveys:(NSSet*)value_;
- (void)removeSurveys:(NSSet*)value_;
- (void)addSurveysObject:(OHMSurvey*)value_;
- (void)removeSurveysObject:(OHMSurvey*)value_;

@end

@interface _OHMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFullName;
- (void)setPrimitiveFullName:(NSString*)value;

- (NSNumber*)primitiveUseCellularData;
- (void)setPrimitiveUseCellularData:(NSNumber*)value;

- (BOOL)primitiveUseCellularDataValue;
- (void)setPrimitiveUseCellularDataValue:(BOOL)value_;

- (NSMutableSet*)primitiveReminderLocations;
- (void)setPrimitiveReminderLocations:(NSMutableSet*)value;

- (NSMutableSet*)primitiveReminders;
- (void)setPrimitiveReminders:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSurveyResponses;
- (void)setPrimitiveSurveyResponses:(NSMutableSet*)value;

- (NSMutableSet*)primitiveSurveys;
- (void)setPrimitiveSurveys:(NSMutableSet*)value;

@end
