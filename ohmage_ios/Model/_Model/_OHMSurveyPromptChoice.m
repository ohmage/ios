// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyPromptChoice.m instead.

#import "_OHMSurveyPromptChoice.h"

const struct OHMSurveyPromptChoiceAttributes OHMSurveyPromptChoiceAttributes = {
	.isDefault = @"isDefault",
	.numberValue = @"numberValue",
	.stringValue = @"stringValue",
	.text = @"text",
};

const struct OHMSurveyPromptChoiceRelationships OHMSurveyPromptChoiceRelationships = {
	.promptResponses = @"promptResponses",
	.surveyItem = @"surveyItem",
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

	if ([key isEqualToString:@"isDefaultValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDefault"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"numberValueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"numberValue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic isDefault;

- (BOOL)isDefaultValue {
	NSNumber *result = [self isDefault];
	return [result boolValue];
}

- (void)setIsDefaultValue:(BOOL)value_ {
	[self setIsDefault:@(value_)];
}

- (BOOL)primitiveIsDefaultValue {
	NSNumber *result = [self primitiveIsDefault];
	return [result boolValue];
}

- (void)setPrimitiveIsDefaultValue:(BOOL)value_ {
	[self setPrimitiveIsDefault:@(value_)];
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

@dynamic stringValue;

@dynamic text;

@dynamic promptResponses;

- (NSMutableSet*)promptResponsesSet {
	[self willAccessValueForKey:@"promptResponses"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"promptResponses"];

	[self didAccessValueForKey:@"promptResponses"];
	return result;
}

@dynamic surveyItem;

@end

