// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMSurveyResponseAttributes {
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

@interface _OHMSurveyResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyResponseID*)objectID;





@property (nonatomic, strong) NSSet *promptResponses;

- (NSMutableSet*)promptResponsesSet;




@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyResponse (CoreDataGeneratedAccessors)

- (void)addPromptResponses:(NSSet*)value_;
- (void)removePromptResponses:(NSSet*)value_;
- (void)addPromptResponsesObject:(OHMSurveyPromptResponse*)value_;
- (void)removePromptResponsesObject:(OHMSurveyPromptResponse*)value_;

@end

@interface _OHMSurveyResponse (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitivePromptResponses;
- (void)setPrimitivePromptResponses:(NSMutableSet*)value;



- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;


@end
