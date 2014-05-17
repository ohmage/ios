// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMSurveyAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *isDue;
	__unsafe_unretained NSString *isLoaded;
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *surveyDescription;
	__unsafe_unretained NSString *surveyName;
	__unsafe_unretained NSString *surveyVersion;
} OHMSurveyAttributes;

extern const struct OHMSurveyRelationships {
	__unsafe_unretained NSString *ohmlet;
	__unsafe_unretained NSString *reminders;
	__unsafe_unretained NSString *surveyItems;
	__unsafe_unretained NSString *surveyResponses;
} OHMSurveyRelationships;

extern const struct OHMSurveyFetchedProperties {
} OHMSurveyFetchedProperties;

@class OHMOhmlet;
@class OHMReminder;
@class OHMSurveyItem;
@class OHMSurveyResponse;









@interface OHMSurveyID : NSManagedObjectID {}
@end

@interface _OHMSurvey : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyID*)objectID;





@property (nonatomic, strong) NSNumber* index;



@property int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isDue;



@property BOOL isDueValue;
- (BOOL)isDueValue;
- (void)setIsDueValue:(BOOL)value_;

//- (BOOL)validateIsDue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isLoaded;



@property BOOL isLoadedValue;
- (BOOL)isLoadedValue;
- (void)setIsLoadedValue:(BOOL)value_;

//- (BOOL)validateIsLoaded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* surveyDescription;



//- (BOOL)validateSurveyDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* surveyName;



//- (BOOL)validateSurveyName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* surveyVersion;



@property int16_t surveyVersionValue;
- (int16_t)surveyVersionValue;
- (void)setSurveyVersionValue:(int16_t)value_;

//- (BOOL)validateSurveyVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMOhmlet *ohmlet;

//- (BOOL)validateOhmlet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *reminders;

- (NSMutableSet*)remindersSet;




@property (nonatomic, strong) NSOrderedSet *surveyItems;

- (NSMutableOrderedSet*)surveyItemsSet;




@property (nonatomic, strong) NSSet *surveyResponses;

- (NSMutableSet*)surveyResponsesSet;





@end

@interface _OHMSurvey (CoreDataGeneratedAccessors)

- (void)addReminders:(NSSet*)value_;
- (void)removeReminders:(NSSet*)value_;
- (void)addRemindersObject:(OHMReminder*)value_;
- (void)removeRemindersObject:(OHMReminder*)value_;

- (void)addSurveyItems:(NSOrderedSet*)value_;
- (void)removeSurveyItems:(NSOrderedSet*)value_;
- (void)addSurveyItemsObject:(OHMSurveyItem*)value_;
- (void)removeSurveyItemsObject:(OHMSurveyItem*)value_;

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




- (NSNumber*)primitiveIsLoaded;
- (void)setPrimitiveIsLoaded:(NSNumber*)value;

- (BOOL)primitiveIsLoadedValue;
- (void)setPrimitiveIsLoadedValue:(BOOL)value_;




- (NSString*)primitiveOhmID;
- (void)setPrimitiveOhmID:(NSString*)value;




- (NSString*)primitiveSurveyDescription;
- (void)setPrimitiveSurveyDescription:(NSString*)value;




- (NSString*)primitiveSurveyName;
- (void)setPrimitiveSurveyName:(NSString*)value;




- (NSNumber*)primitiveSurveyVersion;
- (void)setPrimitiveSurveyVersion:(NSNumber*)value;

- (int16_t)primitiveSurveyVersionValue;
- (void)setPrimitiveSurveyVersionValue:(int16_t)value_;





- (OHMOhmlet*)primitiveOhmlet;
- (void)setPrimitiveOhmlet:(OHMOhmlet*)value;



- (NSMutableSet*)primitiveReminders;
- (void)setPrimitiveReminders:(NSMutableSet*)value;



- (NSMutableOrderedSet*)primitiveSurveyItems;
- (void)setPrimitiveSurveyItems:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitiveSurveyResponses;
- (void)setPrimitiveSurveyResponses:(NSMutableSet*)value;


@end
