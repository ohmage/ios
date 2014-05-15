// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMSurveyResponseAttributes {
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *submissionConfirmed;
	__unsafe_unretained NSString *timestamp;
	__unsafe_unretained NSString *userSubmitted;
} OHMSurveyResponseAttributes;

extern const struct OHMSurveyResponseRelationships {
	__unsafe_unretained NSString *promptResponses;
	__unsafe_unretained NSString *survey;
	__unsafe_unretained NSString *user;
} OHMSurveyResponseRelationships;

extern const struct OHMSurveyResponseFetchedProperties {
} OHMSurveyResponseFetchedProperties;

@class OHMSurveyPromptResponse;
@class OHMSurvey;
@class OHMUser;






@interface OHMSurveyResponseID : NSManagedObjectID {}
@end

@interface _OHMSurveyResponse : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyResponseID*)objectID;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* submissionConfirmed;



@property BOOL submissionConfirmedValue;
- (BOOL)submissionConfirmedValue;
- (void)setSubmissionConfirmedValue:(BOOL)value_;

//- (BOOL)validateSubmissionConfirmed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* timestamp;



//- (BOOL)validateTimestamp:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* userSubmitted;



@property BOOL userSubmittedValue;
- (BOOL)userSubmittedValue;
- (void)setUserSubmittedValue:(BOOL)value_;

//- (BOOL)validateUserSubmitted:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *promptResponses;

- (NSMutableOrderedSet*)promptResponsesSet;




@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





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




- (NSNumber*)primitiveSubmissionConfirmed;
- (void)setPrimitiveSubmissionConfirmed:(NSNumber*)value;

- (BOOL)primitiveSubmissionConfirmedValue;
- (void)setPrimitiveSubmissionConfirmedValue:(BOOL)value_;




- (NSDate*)primitiveTimestamp;
- (void)setPrimitiveTimestamp:(NSDate*)value;




- (NSNumber*)primitiveUserSubmitted;
- (void)setPrimitiveUserSubmitted:(NSNumber*)value;

- (BOOL)primitiveUserSubmittedValue;
- (void)setPrimitiveUserSubmittedValue:(BOOL)value_;





- (NSMutableOrderedSet*)primitivePromptResponses;
- (void)setPrimitivePromptResponses:(NSMutableOrderedSet*)value;



- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;



- (OHMUser*)primitiveUser;
- (void)setPrimitiveUser:(OHMUser*)value;


@end
