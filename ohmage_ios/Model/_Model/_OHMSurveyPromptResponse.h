// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMSurveyPromptResponseAttributes {
	__unsafe_unretained NSString *numberValue;
	__unsafe_unretained NSString *stringValue;
} OHMSurveyPromptResponseAttributes;

extern const struct OHMSurveyPromptResponseRelationships {
	__unsafe_unretained NSString *selectedChoices;
	__unsafe_unretained NSString *surveyItem;
	__unsafe_unretained NSString *surveyResponse;
} OHMSurveyPromptResponseRelationships;

extern const struct OHMSurveyPromptResponseFetchedProperties {
} OHMSurveyPromptResponseFetchedProperties;

@class OHMSurveyPromptChoice;
@class OHMSurveyItem;
@class OHMSurveyResponse;




@interface OHMSurveyPromptResponseID : NSManagedObjectID {}
@end

@interface _OHMSurveyPromptResponse : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyPromptResponseID*)objectID;





@property (nonatomic, strong) NSNumber* numberValue;



@property double numberValueValue;
- (double)numberValueValue;
- (void)setNumberValueValue:(double)value_;

//- (BOOL)validateNumberValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stringValue;



//- (BOOL)validateStringValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *selectedChoices;

- (NSMutableSet*)selectedChoicesSet;




@property (nonatomic, strong) OHMSurveyItem *surveyItem;

//- (BOOL)validateSurveyItem:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;

//- (BOOL)validateSurveyResponse:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyPromptResponse (CoreDataGeneratedAccessors)

- (void)addSelectedChoices:(NSSet*)value_;
- (void)removeSelectedChoices:(NSSet*)value_;
- (void)addSelectedChoicesObject:(OHMSurveyPromptChoice*)value_;
- (void)removeSelectedChoicesObject:(OHMSurveyPromptChoice*)value_;

@end

@interface _OHMSurveyPromptResponse (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(NSNumber*)value;

- (double)primitiveNumberValueValue;
- (void)setPrimitiveNumberValueValue:(double)value_;




- (NSString*)primitiveStringValue;
- (void)setPrimitiveStringValue:(NSString*)value;





- (NSMutableSet*)primitiveSelectedChoices;
- (void)setPrimitiveSelectedChoices:(NSMutableSet*)value;



- (OHMSurveyItem*)primitiveSurveyItem;
- (void)setPrimitiveSurveyItem:(OHMSurveyItem*)value;



- (OHMSurveyResponse*)primitiveSurveyResponse;
- (void)setPrimitiveSurveyResponse:(OHMSurveyResponse*)value;


@end
