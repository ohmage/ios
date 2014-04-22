// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptChoice.m instead.

#import "_OHMSurveyPromptChoice.h"

const struct OHMSurveyPromptChoiceAttributes OHMSurveyPromptChoiceAttributes = {
	.text = @"text",
	.value = @"value",
};

const struct OHMSurveyPromptChoiceRelationships OHMSurveyPromptChoiceRelationships = {
	.surveyItem = @"surveyItem",
};

const struct OHMSurveyPromptChoiceFetchedProperties OHMSurveyPromptChoiceFetchedProperties = {
};

@implementation OHMSurveyPromptChoiceID
@end

@implementation _OHMSurveyPromptChoice

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMSurveyPromptChoice" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMSurveyPromptChoice";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMSurveyPromptChoice" inManagedObjectContext:moc_];
}

- (OHMSurveyPromptChoiceID*)objectID {
	return (OHMSurveyPromptChoiceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic text;






@dynamic value;






@dynamic surveyItem;

	






@end
