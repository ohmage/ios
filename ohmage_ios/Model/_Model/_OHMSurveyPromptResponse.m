// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.m instead.

#import "_OHMSurveyPromptResponse.h"

const struct OHMSurveyPromptResponseAttributes OHMSurveyPromptResponseAttributes = {
	.value = @"value",
};

const struct OHMSurveyPromptResponseRelationships OHMSurveyPromptResponseRelationships = {
	.surveyItem = @"surveyItem",
	.surveyResponse = @"surveyResponse",
};

const struct OHMSurveyPromptResponseFetchedProperties OHMSurveyPromptResponseFetchedProperties = {
};

@implementation OHMSurveyPromptResponseID
@end

@implementation _OHMSurveyPromptResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMSurveyPromptResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMSurveyPromptResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMSurveyPromptResponse" inManagedObjectContext:moc_];
}

- (OHMSurveyPromptResponseID*)objectID {
	return (OHMSurveyPromptResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic value;






@dynamic surveyItem;

	

@dynamic surveyResponse;

	






@end
