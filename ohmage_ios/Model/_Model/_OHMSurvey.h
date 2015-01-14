// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.h instead.

@import CoreData;

extern const struct OHMSurveyAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *isDue;
	__unsafe_unretained NSString *schemaName;
	__unsafe_unretained NSString *schemaNamespace;
	__unsafe_unretained NSString *schemaVersion;
	__unsafe_unretained NSString *surveyDescription;
	__unsafe_unretained NSString *surveyName;
} OHMSurveyAttributes;

extern const struct OHMSurveyRelationships {
	__unsafe_unretained NSString *reminders;
	__unsafe_unretained NSString *surveyItems;
	__unsafe_unretained NSString *surveyResponses;
	__unsafe_unretained NSString *user;
} OHMSurveyRelationships;

@class OHMReminder;
@class OHMSurveyItem;
@class OHMSurveyResponse;
@class OHMUser;

@interface OHMSurveyID : NSManagedObjectID {}
@end

@interface _OHMSurvey : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) OHMSurveyID* objectID;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isDue;

@property (atomic) BOOL isDueValue;
- (BOOL)isDueValue;
- (void)setIsDueValue:(BOOL)value_;

//- (BOOL)validateIsDue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* schemaName;

//- (BOOL)validateSchemaName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* schemaNamespace;

//- (BOOL)validateSchemaNamespace:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* schemaVersion;

//- (BOOL)validateSchemaVersion:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* surveyDescription;

//- (BOOL)validateSurveyDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* surveyName;

//- (BOOL)validateSurveyName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *reminders;

- (NSMutableSet*)remindersSet;

@property (nonatomic, strong) NSOrderedSet *surveyItems;

- (NSMutableOrderedSet*)surveyItemsSet;

@property (nonatomic, strong) NSSet *surveyResponses;

- (NSMutableSet*)surveyResponsesSet;

@property (nonatomic, strong) OHMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _OHMSurvey (RemindersCoreDataGeneratedAccessors)
- (void)addReminders:(NSSet*)value_;
- (void)removeReminders:(NSSet*)value_;
- (void)addRemindersObject:(OHMReminder*)value_;
- (void)removeRemindersObject:(OHMReminder*)value_;

@end

@interface _OHMSurvey (SurveyItemsCoreDataGeneratedAccessors)
- (void)addSurveyItems:(NSOrderedSet*)value_;
- (void)removeSurveyItems:(NSOrderedSet*)value_;
- (void)addSurveyItemsObject:(OHMSurveyItem*)value_;
- (void)removeSurveyItemsObject:(OHMSurveyItem*)value_;

- (void)insertObject:(OHMSurveyItem*)value inSurveyItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSurveyItemsAtIndex:(NSUInteger)idx;
- (void)insertSurveyItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSurveyItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSurveyItemsAtIndex:(NSUInteger)idx withObject:(OHMSurveyItem*)value;
- (void)replaceSurveyItemsAtIndexes:(NSIndexSet *)indexes withSurveyItems:(NSArray *)values;

@end

@interface _OHMSurvey (SurveyResponsesCoreDataGeneratedAccessors)
- (void)addSurveyResponses:(NSSet*)value_;
- (void)removeSurveyResponses:(NSSet*)value_;
- (void)addSurveyResponsesObject:(OHMSurveyResponse*)value_;
- (void)removeSurveyResponsesObject:(OHMSurveyResponse*)value_;

@end

@interface _OHMSurvey (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;

- (NSNumber*)primitiveIsDue;
- (void)setPrimitiveIsDue:(NSNumber*)value;

- (BOOL)primitiveIsDueValue;
- (void)setPrimitiveIsDueValue:(BOOL)value_;

- (NSString*)primitiveSchemaName;
- (void)setPrimitiveSchemaName:(NSString*)value;

- (NSString*)primitiveSchemaNamespace;
- (void)setPrimitiveSchemaNamespace:(NSString*)value;

- (NSString*)primitiveSchemaVersion;
- (void)setPrimitiveSchemaVersion:(NSString*)value;

- (NSString*)primitiveSurveyDescription;
- (void)setPrimitiveSurveyDescription:(NSString*)value;

- (NSString*)primitiveSurveyName;
- (void)setPrimitiveSurveyName:(NSString*)value;

- (NSMutableSet*)primitiveReminders;
- (void)setPrimitiveReminders:(NSMutableSet*)value;

- (NSMutableOrderedSet*)primitiveSurveyItems;
- (void)setPrimitiveSurveyItems:(NSMutableOrderedSet*)value;

- (NSMutableSet*)primitiveSurveyResponses;
- (void)setPrimitiveSurveyResponses:(NSMutableSet*)value;

- (OHMUser*)primitiveUser;
- (void)setPrimitiveUser:(OHMUser*)value;

@end
