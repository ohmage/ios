// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyItem.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMSurveyItemAttributes {
	__unsafe_unretained NSString *condition;
	__unsafe_unretained NSString *defaultResponse;
	__unsafe_unretained NSString *displayLabel;
	__unsafe_unretained NSString *displayType;
	__unsafe_unretained NSString *itemId;
	__unsafe_unretained NSString *itemType;
	__unsafe_unretained NSString *max;
	__unsafe_unretained NSString *maxChoices;
	__unsafe_unretained NSString *maxDimension;
	__unsafe_unretained NSString *maxDuration;
	__unsafe_unretained NSString *min;
	__unsafe_unretained NSString *minChoices;
	__unsafe_unretained NSString *skippable;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *wholeNumbersOnly;
} OHMSurveyItemAttributes;

extern const struct OHMSurveyItemRelationships {
	__unsafe_unretained NSString *choices;
	__unsafe_unretained NSString *responses;
	__unsafe_unretained NSString *survey;
} OHMSurveyItemRelationships;

extern const struct OHMSurveyItemFetchedProperties {
} OHMSurveyItemFetchedProperties;

@class OHMSurveyPromptChoice;
@class OHMSurveyPromptResponse;
@class OHMSurvey;

















@interface OHMSurveyItemID : NSManagedObjectID {}
@end

@interface _OHMSurveyItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyItemID*)objectID;





@property (nonatomic, strong) NSString* condition;



//- (BOOL)validateCondition:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* defaultResponse;



//- (BOOL)validateDefaultResponse:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* displayLabel;



//- (BOOL)validateDisplayLabel:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* displayType;



//- (BOOL)validateDisplayType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* itemId;



//- (BOOL)validateItemId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* itemType;



@property int16_t itemTypeValue;
- (int16_t)itemTypeValue;
- (void)setItemTypeValue:(int16_t)value_;

//- (BOOL)validateItemType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* max;



//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* maxChoices;



//- (BOOL)validateMaxChoices:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* maxDimension;



//- (BOOL)validateMaxDimension:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* maxDuration;



//- (BOOL)validateMaxDuration:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* min;



//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* minChoices;



//- (BOOL)validateMinChoices:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* skippable;



@property BOOL skippableValue;
- (BOOL)skippableValue;
- (void)setSkippableValue:(BOOL)value_;

//- (BOOL)validateSkippable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* wholeNumbersOnly;



@property BOOL wholeNumbersOnlyValue;
- (BOOL)wholeNumbersOnlyValue;
- (void)setWholeNumbersOnlyValue:(BOOL)value_;

//- (BOOL)validateWholeNumbersOnly:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMSurveyPromptChoice *choices;

//- (BOOL)validateChoices:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *responses;

- (NSMutableSet*)responsesSet;




@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyItem (CoreDataGeneratedAccessors)

- (void)addResponses:(NSSet*)value_;
- (void)removeResponses:(NSSet*)value_;
- (void)addResponsesObject:(OHMSurveyPromptResponse*)value_;
- (void)removeResponsesObject:(OHMSurveyPromptResponse*)value_;

@end

@interface _OHMSurveyItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCondition;
- (void)setPrimitiveCondition:(NSString*)value;




- (NSString*)primitiveDefaultResponse;
- (void)setPrimitiveDefaultResponse:(NSString*)value;




- (NSString*)primitiveDisplayLabel;
- (void)setPrimitiveDisplayLabel:(NSString*)value;




- (NSString*)primitiveDisplayType;
- (void)setPrimitiveDisplayType:(NSString*)value;




- (NSString*)primitiveItemId;
- (void)setPrimitiveItemId:(NSString*)value;




- (NSNumber*)primitiveItemType;
- (void)setPrimitiveItemType:(NSNumber*)value;

- (int16_t)primitiveItemTypeValue;
- (void)setPrimitiveItemTypeValue:(int16_t)value_;




- (NSString*)primitiveMax;
- (void)setPrimitiveMax:(NSString*)value;




- (NSString*)primitiveMaxChoices;
- (void)setPrimitiveMaxChoices:(NSString*)value;




- (NSString*)primitiveMaxDimension;
- (void)setPrimitiveMaxDimension:(NSString*)value;




- (NSString*)primitiveMaxDuration;
- (void)setPrimitiveMaxDuration:(NSString*)value;




- (NSString*)primitiveMin;
- (void)setPrimitiveMin:(NSString*)value;




- (NSString*)primitiveMinChoices;
- (void)setPrimitiveMinChoices:(NSString*)value;




- (NSNumber*)primitiveSkippable;
- (void)setPrimitiveSkippable:(NSNumber*)value;

- (BOOL)primitiveSkippableValue;
- (void)setPrimitiveSkippableValue:(BOOL)value_;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSNumber*)primitiveWholeNumbersOnly;
- (void)setPrimitiveWholeNumbersOnly:(NSNumber*)value;

- (BOOL)primitiveWholeNumbersOnlyValue;
- (void)setPrimitiveWholeNumbersOnlyValue:(BOOL)value_;





- (OHMSurveyPromptChoice*)primitiveChoices;
- (void)setPrimitiveChoices:(OHMSurveyPromptChoice*)value;



- (NSMutableSet*)primitiveResponses;
- (void)setPrimitiveResponses:(NSMutableSet*)value;



- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;


@end
