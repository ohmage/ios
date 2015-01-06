// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.h instead.

@import CoreData;

extern const struct OHMSurveyPromptResponseAttributes {
	__unsafe_unretained NSString *notDisplayed;
	__unsafe_unretained NSString *numberValue;
	__unsafe_unretained NSString *skipped;
	__unsafe_unretained NSString *stringValue;
	__unsafe_unretained NSString *timestampValue;
	__unsafe_unretained NSString *uuid;
} OHMSurveyPromptResponseAttributes;

extern const struct OHMSurveyPromptResponseRelationships {
	__unsafe_unretained NSString *selectedChoices;
	__unsafe_unretained NSString *surveyItem;
	__unsafe_unretained NSString *surveyResponse;
} OHMSurveyPromptResponseRelationships;

@class OHMSurveyPromptChoice;
@class OHMSurveyItem;
@class OHMSurveyResponse;

@interface OHMSurveyPromptResponseID : NSManagedObjectID {}
@end

@interface _OHMSurveyPromptResponse : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) OHMSurveyPromptResponseID* objectID;

@property (nonatomic, strong) NSNumber* notDisplayed;

@property (atomic) BOOL notDisplayedValue;
- (BOOL)notDisplayedValue;
- (void)setNotDisplayedValue:(BOOL)value_;

//- (BOOL)validateNotDisplayed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* numberValue;

@property (atomic) double numberValueValue;
- (double)numberValueValue;
- (void)setNumberValueValue:(double)value_;

//- (BOOL)validateNumberValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* skipped;

@property (atomic) BOOL skippedValue;
- (BOOL)skippedValue;
- (void)setSkippedValue:(BOOL)value_;

//- (BOOL)validateSkipped:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* stringValue;

//- (BOOL)validateStringValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* timestampValue;

//- (BOOL)validateTimestampValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *selectedChoices;

- (NSMutableSet*)selectedChoicesSet;

@property (nonatomic, strong) OHMSurveyItem *surveyItem;

//- (BOOL)validateSurveyItem:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;

//- (BOOL)validateSurveyResponse:(id*)value_ error:(NSError**)error_;

@end

@interface _OHMSurveyPromptResponse (SelectedChoicesCoreDataGeneratedAccessors)
- (void)addSelectedChoices:(NSSet*)value_;
- (void)removeSelectedChoices:(NSSet*)value_;
- (void)addSelectedChoicesObject:(OHMSurveyPromptChoice*)value_;
- (void)removeSelectedChoicesObject:(OHMSurveyPromptChoice*)value_;

@end

@interface _OHMSurveyPromptResponse (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveNotDisplayed;
- (void)setPrimitiveNotDisplayed:(NSNumber*)value;

- (BOOL)primitiveNotDisplayedValue;
- (void)setPrimitiveNotDisplayedValue:(BOOL)value_;

- (NSNumber*)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(NSNumber*)value;

- (double)primitiveNumberValueValue;
- (void)setPrimitiveNumberValueValue:(double)value_;

- (NSNumber*)primitiveSkipped;
- (void)setPrimitiveSkipped:(NSNumber*)value;

- (BOOL)primitiveSkippedValue;
- (void)setPrimitiveSkippedValue:(BOOL)value_;

- (NSString*)primitiveStringValue;
- (void)setPrimitiveStringValue:(NSString*)value;

- (NSDate*)primitiveTimestampValue;
- (void)setPrimitiveTimestampValue:(NSDate*)value;

- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;

- (NSMutableSet*)primitiveSelectedChoices;
- (void)setPrimitiveSelectedChoices:(NSMutableSet*)value;

- (OHMSurveyItem*)primitiveSurveyItem;
- (void)setPrimitiveSurveyItem:(OHMSurveyItem*)value;

- (OHMSurveyResponse*)primitiveSurveyResponse;
- (void)setPrimitiveSurveyResponse:(OHMSurveyResponse*)value;

@end
