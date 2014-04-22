// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMSurveyAttributes {
	__unsafe_unretained NSString *surveyDescription;
	__unsafe_unretained NSString *surveyId;
	__unsafe_unretained NSString *surveyName;
	__unsafe_unretained NSString *version;
} OHMSurveyAttributes;

extern const struct OHMSurveyRelationships {
	__unsafe_unretained NSString *ohmlet;
	__unsafe_unretained NSString *surveyItems;
	__unsafe_unretained NSString *surveyResponses;
} OHMSurveyRelationships;

extern const struct OHMSurveyFetchedProperties {
} OHMSurveyFetchedProperties;

@class OHMOhmlet;
@class OHMSurveyItem;
@class OHMSurveyResponse;






@interface OHMSurveyID : NSManagedObjectID {}
@end

@interface _OHMSurvey : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyID*)objectID;





@property (nonatomic, strong) NSString* surveyDescription;



//- (BOOL)validateSurveyDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* surveyId;



//- (BOOL)validateSurveyId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* surveyName;



//- (BOOL)validateSurveyName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* version;



@property int16_t versionValue;
- (int16_t)versionValue;
- (void)setVersionValue:(int16_t)value_;

//- (BOOL)validateVersion:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMOhmlet *ohmlet;

//- (BOOL)validateOhmlet:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *surveyItems;

- (NSMutableSet*)surveyItemsSet;




@property (nonatomic, strong) NSSet *surveyResponses;

- (NSMutableSet*)surveyResponsesSet;





@end

@interface _OHMSurvey (CoreDataGeneratedAccessors)

- (void)addSurveyItems:(NSSet*)value_;
- (void)removeSurveyItems:(NSSet*)value_;
- (void)addSurveyItemsObject:(OHMSurveyItem*)value_;
- (void)removeSurveyItemsObject:(OHMSurveyItem*)value_;

- (void)addSurveyResponses:(NSSet*)value_;
- (void)removeSurveyResponses:(NSSet*)value_;
- (void)addSurveyResponsesObject:(OHMSurveyResponse*)value_;
- (void)removeSurveyResponsesObject:(OHMSurveyResponse*)value_;

@end

@interface _OHMSurvey (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSurveyDescription;
- (void)setPrimitiveSurveyDescription:(NSString*)value;




- (NSString*)primitiveSurveyId;
- (void)setPrimitiveSurveyId:(NSString*)value;




- (NSString*)primitiveSurveyName;
- (void)setPrimitiveSurveyName:(NSString*)value;




- (NSNumber*)primitiveVersion;
- (void)setPrimitiveVersion:(NSNumber*)value;

- (int16_t)primitiveVersionValue;
- (void)setPrimitiveVersionValue:(int16_t)value_;





- (OHMOhmlet*)primitiveOhmlet;
- (void)setPrimitiveOhmlet:(OHMOhmlet*)value;



- (NSMutableSet*)primitiveSurveyItems;
- (void)setPrimitiveSurveyItems:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSurveyResponses;
- (void)setPrimitiveSurveyResponses:(NSMutableSet*)value;


@end
