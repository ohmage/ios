// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMSurveyPromptResponseAttributes {
	__unsafe_unretained NSString *value;
} OHMSurveyPromptResponseAttributes;

extern const struct OHMSurveyPromptResponseRelationships {
	__unsafe_unretained NSString *surveyItem;
	__unsafe_unretained NSString *surveyResponse;
} OHMSurveyPromptResponseRelationships;

extern const struct OHMSurveyPromptResponseFetchedProperties {
} OHMSurveyPromptResponseFetchedProperties;

@class OHMSurveyItem;
@class OHMSurveyResponse;



@interface OHMSurveyPromptResponseID : NSManagedObjectID {}
@end

@interface _OHMSurveyPromptResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyPromptResponseID*)objectID;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMSurveyItem *surveyItem;

//- (BOOL)validateSurveyItem:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;

//- (BOOL)validateSurveyResponse:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyPromptResponse (CoreDataGeneratedAccessors)

@end

@interface _OHMSurveyPromptResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;





- (OHMSurveyItem*)primitiveSurveyItem;
- (void)setPrimitiveSurveyItem:(OHMSurveyItem*)value;



- (OHMSurveyResponse*)primitiveSurveyResponse;
- (void)setPrimitiveSurveyResponse:(OHMSurveyResponse*)value;


@end
