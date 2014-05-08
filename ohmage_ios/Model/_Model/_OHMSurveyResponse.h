// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMSurveyResponseAttributes {
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *submitted;
	__unsafe_unretained NSString *timestamp;
} OHMSurveyResponseAttributes;

extern const struct OHMSurveyResponseRelationships {
	__unsafe_unretained NSString *promptResponses;
	__unsafe_unretained NSString *survey;
} OHMSurveyResponseRelationships;

extern const struct OHMSurveyResponseFetchedProperties {
} OHMSurveyResponseFetchedProperties;

@class OHMSurveyPromptResponse;
@class OHMSurvey;





@interface OHMSurveyResponseID : NSManagedObjectID {}
@end

@interface _OHMSurveyResponse : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyResponseID*)objectID;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* submitted;



@property BOOL submittedValue;
- (BOOL)submittedValue;
- (void)setSubmittedValue:(BOOL)value_;

//- (BOOL)validateSubmitted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timestamp;



//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *promptResponses;

- (NSMutableOrderedSet*)promptResponsesSet;




@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyResponse (CoreDataGeneratedAccessors)

- (void)addPromptResponses:(NSOrderedSet*)value_;
- (void)removePromptResponses:(NSOrderedSet*)value_;
- (void)addPromptResponsesObject:(OHMSurveyPromptResponse*)value_;
- (void)removePromptResponsesObject:(OHMSurveyPromptResponse*)value_;

@end

@interface _OHMSurveyResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveOhmID;
- (void)setPrimitiveOhmID:(NSString*)value;




- (NSNumber*)primitiveSubmitted;
- (void)setPrimitiveSubmitted:(NSNumber*)value;

- (BOOL)primitiveSubmittedValue;
- (void)setPrimitiveSubmittedValue:(BOOL)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;





- (NSMutableOrderedSet*)primitivePromptResponses;
- (void)setPrimitivePromptResponses:(NSMutableOrderedSet*)value;



- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;


@end
