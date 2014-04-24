// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptChoice.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMSurveyPromptChoiceAttributes {
	__unsafe_unretained NSString *isDefault;
	__unsafe_unretained NSString *numberValue;
	__unsafe_unretained NSString *stringValue;
	__unsafe_unretained NSString *text;
} OHMSurveyPromptChoiceAttributes;

extern const struct OHMSurveyPromptChoiceRelationships {
	__unsafe_unretained NSString *survetItemWithDefaults;
	__unsafe_unretained NSString *surveyItem;
} OHMSurveyPromptChoiceRelationships;

extern const struct OHMSurveyPromptChoiceFetchedProperties {
} OHMSurveyPromptChoiceFetchedProperties;

@class OHMSurveyItem;
@class OHMSurveyItem;






@interface OHMSurveyPromptChoiceID : NSManagedObjectID {}
@end

@interface _OHMSurveyPromptChoice : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyPromptChoiceID*)objectID;





@property (nonatomic, strong) NSNumber* isDefault;



@property BOOL isDefaultValue;
- (BOOL)isDefaultValue;
- (void)setIsDefaultValue:(BOOL)value_;

//- (BOOL)validateIsDefault:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* numberValue;



@property double numberValueValue;
- (double)numberValueValue;
- (void)setNumberValueValue:(double)value_;

//- (BOOL)validateNumberValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* stringValue;



//- (BOOL)validateStringValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMSurveyItem *survetItemWithDefaults;

//- (BOOL)validateSurvetItemWithDefaults:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) OHMSurveyItem *surveyItem;

//- (BOOL)validateSurveyItem:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyPromptChoice (CoreDataGeneratedAccessors)

@end

@interface _OHMSurveyPromptChoice (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIsDefault;
- (void)setPrimitiveIsDefault:(NSNumber*)value;

- (BOOL)primitiveIsDefaultValue;
- (void)setPrimitiveIsDefaultValue:(BOOL)value_;




- (NSNumber*)primitiveNumberValue;
- (void)setPrimitiveNumberValue:(NSNumber*)value;

- (double)primitiveNumberValueValue;
- (void)setPrimitiveNumberValueValue:(double)value_;




- (NSString*)primitiveStringValue;
- (void)setPrimitiveStringValue:(NSString*)value;




- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;





- (OHMSurveyItem*)primitiveSurvetItemWithDefaults;
- (void)setPrimitiveSurvetItemWithDefaults:(OHMSurveyItem*)value;



- (OHMSurveyItem*)primitiveSurveyItem;
- (void)setPrimitiveSurveyItem:(OHMSurveyItem*)value;


@end
