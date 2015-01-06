// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyItem.h instead.

@import CoreData;

extern const struct OHMSurveyItemAttributes {
	__unsafe_unretained NSString *condition;
	__unsafe_unretained NSString *defaultNumberResponse;
	__unsafe_unretained NSString *defaultStringResponse;
	__unsafe_unretained NSString *displayLabel;
	__unsafe_unretained NSString *displayType;
	__unsafe_unretained NSString *itemID;
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

@class OHMSurveyPromptChoice;
@class OHMSurveyPromptResponse;
@class OHMSurvey;

@interface OHMSurveyItemID : NSManagedObjectID {}
@end

@interface _OHMSurveyItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) OHMSurveyItemID* objectID;

@property (nonatomic, strong) NSString* condition;

//- (BOOL)validateCondition:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* defaultNumberResponse;

@property (atomic) double defaultNumberResponseValue;
- (double)defaultNumberResponseValue;
- (void)setDefaultNumberResponseValue:(double)value_;

//- (BOOL)validateDefaultNumberResponse:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* defaultStringResponse;

//- (BOOL)validateDefaultStringResponse:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayLabel;

//- (BOOL)validateDisplayLabel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayType;

//- (BOOL)validateDisplayType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* itemID;

//- (BOOL)validateItemID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* itemType;

@property (atomic) int16_t itemTypeValue;
- (int16_t)itemTypeValue;
- (void)setItemTypeValue:(int16_t)value_;

//- (BOOL)validateItemType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* max;

@property (atomic) double maxValue;
- (double)maxValue;
- (void)setMaxValue:(double)value_;

//- (BOOL)validateMax:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* maxChoices;

@property (atomic) int16_t maxChoicesValue;
- (int16_t)maxChoicesValue;
- (void)setMaxChoicesValue:(int16_t)value_;

//- (BOOL)validateMaxChoices:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* maxDimension;

@property (atomic) int32_t maxDimensionValue;
- (int32_t)maxDimensionValue;
- (void)setMaxDimensionValue:(int32_t)value_;

//- (BOOL)validateMaxDimension:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* maxDuration;

@property (atomic) int32_t maxDurationValue;
- (int32_t)maxDurationValue;
- (void)setMaxDurationValue:(int32_t)value_;

//- (BOOL)validateMaxDuration:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* min;

@property (atomic) double minValue;
- (double)minValue;
- (void)setMinValue:(double)value_;

//- (BOOL)validateMin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* minChoices;

@property (atomic) int16_t minChoicesValue;
- (int16_t)minChoicesValue;
- (void)setMinChoicesValue:(int16_t)value_;

//- (BOOL)validateMinChoices:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* skippable;

@property (atomic) BOOL skippableValue;
- (BOOL)skippableValue;
- (void)setSkippableValue:(BOOL)value_;

//- (BOOL)validateSkippable:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* wholeNumbersOnly;

@property (atomic) BOOL wholeNumbersOnlyValue;
- (BOOL)wholeNumbersOnlyValue;
- (void)setWholeNumbersOnlyValue:(BOOL)value_;

//- (BOOL)validateWholeNumbersOnly:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *choices;

- (NSMutableOrderedSet*)choicesSet;

@property (nonatomic, strong) NSSet *responses;

- (NSMutableSet*)responsesSet;

@property (nonatomic, strong) OHMSurvey *survey;

//- (BOOL)validateSurvey:(id*)value_ error:(NSError**)error_;

@end

@interface _OHMSurveyItem (ChoicesCoreDataGeneratedAccessors)
- (void)addChoices:(NSOrderedSet*)value_;
- (void)removeChoices:(NSOrderedSet*)value_;
- (void)addChoicesObject:(OHMSurveyPromptChoice*)value_;
- (void)removeChoicesObject:(OHMSurveyPromptChoice*)value_;

- (void)insertObject:(OHMSurveyPromptChoice*)value inChoicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChoicesAtIndex:(NSUInteger)idx;
- (void)insertChoices:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChoicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChoicesAtIndex:(NSUInteger)idx withObject:(OHMSurveyPromptChoice*)value;
- (void)replaceChoicesAtIndexes:(NSIndexSet *)indexes withChoices:(NSArray *)values;

@end

@interface _OHMSurveyItem (ResponsesCoreDataGeneratedAccessors)
- (void)addResponses:(NSSet*)value_;
- (void)removeResponses:(NSSet*)value_;
- (void)addResponsesObject:(OHMSurveyPromptResponse*)value_;
- (void)removeResponsesObject:(OHMSurveyPromptResponse*)value_;

@end

@interface _OHMSurveyItem (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCondition;
- (void)setPrimitiveCondition:(NSString*)value;

- (NSNumber*)primitiveDefaultNumberResponse;
- (void)setPrimitiveDefaultNumberResponse:(NSNumber*)value;

- (double)primitiveDefaultNumberResponseValue;
- (void)setPrimitiveDefaultNumberResponseValue:(double)value_;

- (NSString*)primitiveDefaultStringResponse;
- (void)setPrimitiveDefaultStringResponse:(NSString*)value;

- (NSString*)primitiveDisplayLabel;
- (void)setPrimitiveDisplayLabel:(NSString*)value;

- (NSString*)primitiveDisplayType;
- (void)setPrimitiveDisplayType:(NSString*)value;

- (NSString*)primitiveItemID;
- (void)setPrimitiveItemID:(NSString*)value;

- (NSNumber*)primitiveItemType;
- (void)setPrimitiveItemType:(NSNumber*)value;

- (int16_t)primitiveItemTypeValue;
- (void)setPrimitiveItemTypeValue:(int16_t)value_;

- (NSNumber*)primitiveMax;
- (void)setPrimitiveMax:(NSNumber*)value;

- (double)primitiveMaxValue;
- (void)setPrimitiveMaxValue:(double)value_;

- (NSNumber*)primitiveMaxChoices;
- (void)setPrimitiveMaxChoices:(NSNumber*)value;

- (int16_t)primitiveMaxChoicesValue;
- (void)setPrimitiveMaxChoicesValue:(int16_t)value_;

- (NSNumber*)primitiveMaxDimension;
- (void)setPrimitiveMaxDimension:(NSNumber*)value;

- (int32_t)primitiveMaxDimensionValue;
- (void)setPrimitiveMaxDimensionValue:(int32_t)value_;

- (NSNumber*)primitiveMaxDuration;
- (void)setPrimitiveMaxDuration:(NSNumber*)value;

- (int32_t)primitiveMaxDurationValue;
- (void)setPrimitiveMaxDurationValue:(int32_t)value_;

- (NSNumber*)primitiveMin;
- (void)setPrimitiveMin:(NSNumber*)value;

- (double)primitiveMinValue;
- (void)setPrimitiveMinValue:(double)value_;

- (NSNumber*)primitiveMinChoices;
- (void)setPrimitiveMinChoices:(NSNumber*)value;

- (int16_t)primitiveMinChoicesValue;
- (void)setPrimitiveMinChoicesValue:(int16_t)value_;

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

- (NSMutableOrderedSet*)primitiveChoices;
- (void)setPrimitiveChoices:(NSMutableOrderedSet*)value;

- (NSMutableSet*)primitiveResponses;
- (void)setPrimitiveResponses:(NSMutableSet*)value;

- (OHMSurvey*)primitiveSurvey;
- (void)setPrimitiveSurvey:(OHMSurvey*)value;

@end
