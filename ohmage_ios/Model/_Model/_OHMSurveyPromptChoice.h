// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptChoice.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMSurveyPromptChoiceAttributes {
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *value;
} OHMSurveyPromptChoiceAttributes;

extern const struct OHMSurveyPromptChoiceRelationships {
	__unsafe_unretained NSString *surveyItem;
} OHMSurveyPromptChoiceRelationships;

extern const struct OHMSurveyPromptChoiceFetchedProperties {
} OHMSurveyPromptChoiceFetchedProperties;

@class OHMSurveyItem;




@interface OHMSurveyPromptChoiceID : NSManagedObjectID {}
@end

@interface _OHMSurveyPromptChoice : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMSurveyPromptChoiceID*)objectID;





@property (nonatomic, strong) NSString* text;



//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OHMSurveyItem *surveyItem;

//- (BOOL)validateSurveyItem:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMSurveyPromptChoice (CoreDataGeneratedAccessors)

@end

@interface _OHMSurveyPromptChoice (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;





- (OHMSurveyItem*)primitiveSurveyItem;
- (void)setPrimitiveSurveyItem:(OHMSurveyItem*)value;


@end
