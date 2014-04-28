// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.m instead.

#import "_OHMSurveyPromptResponse.h"

const struct OHMSurveyPromptResponseAttributes OHMSurveyPromptResponseAttributes = {
	.numberValue = @"numberValue",
	.stringValue = @"stringValue",
};

const struct OHMSurveyPromptResponseRelationships OHMSurveyPromptResponseRelationships = {
	.selectedChoices = @"selectedChoices",
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
	
	if ([key isEqualToString:@"numberValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic numberValue;



- (double)numberValueValue {
	NSNumber *result = [self numberValue];
	return [result doubleValue];
}

- (void)setNumberValueValue:(double)value_ {
	[self setNumberValue:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveNumberValueValue {
	NSNumber *result = [self primitiveNumberValue];
	return [result doubleValue];
}

- (void)setPrimitiveNumberValueValue:(double)value_ {
	[self setPrimitiveNumberValue:[NSNumber numberWithDouble:value_]];
}





@dynamic stringValue;






@dynamic selectedChoices;

	
- (NSMutableSet*)selectedChoicesSet {
	[self willAccessValueForKey:@"selectedChoices"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"selectedChoices"];
  
	[self didAccessValueForKey:@"selectedChoices"];
	return result;
}
	

@dynamic surveyItem;

	

@dynamic surveyResponse;

	






@end
