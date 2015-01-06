// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptResponse.m instead.

#import "_OHMSurveyPromptResponse.h"

const struct OHMSurveyPromptResponseAttributes OHMSurveyPromptResponseAttributes = {
	.notDisplayed = @"notDisplayed",
	.numberValue = @"numberValue",
	.skipped = @"skipped",
	.stringValue = @"stringValue",
	.timestampValue = @"timestampValue",
	.uuid = @"uuid",
};

const struct OHMSurveyPromptResponseRelationships OHMSurveyPromptResponseRelationships = {
	.selectedChoices = @"selectedChoices",
	.surveyItem = @"surveyItem",
	.surveyResponse = @"surveyResponse",
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

	if ([key isEqualToString:@"notDisplayedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notDisplayed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"skippedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"skipped"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic notDisplayed;

- (BOOL)notDisplayedValue {
	NSNumber *result = [self notDisplayed];
	return [result boolValue];
}

- (void)setNotDisplayedValue:(BOOL)value_ {
	[self setNotDisplayed:@(value_)];
}

- (BOOL)primitiveNotDisplayedValue {
	NSNumber *result = [self primitiveNotDisplayed];
	return [result boolValue];
}

- (void)setPrimitiveNotDisplayedValue:(BOOL)value_ {
	[self setPrimitiveNotDisplayed:@(value_)];
}

@dynamic numberValue;

- (double)numberValueValue {
	NSNumber *result = [self numberValue];
	return [result doubleValue];
}

- (void)setNumberValueValue:(double)value_ {
	[self setNumberValue:@(value_)];
}

- (double)primitiveNumberValueValue {
	NSNumber *result = [self primitiveNumberValue];
	return [result doubleValue];
}

- (void)setPrimitiveNumberValueValue:(double)value_ {
	[self setPrimitiveNumberValue:@(value_)];
}

@dynamic skipped;

- (BOOL)skippedValue {
	NSNumber *result = [self skipped];
	return [result boolValue];
}

- (void)setSkippedValue:(BOOL)value_ {
	[self setSkipped:@(value_)];
}

- (BOOL)primitiveSkippedValue {
	NSNumber *result = [self primitiveSkipped];
	return [result boolValue];
}

- (void)setPrimitiveSkippedValue:(BOOL)value_ {
	[self setPrimitiveSkipped:@(value_)];
}

@dynamic stringValue;

@dynamic timestampValue;

@dynamic uuid;

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

