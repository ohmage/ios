// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.m instead.

#import "_OHMSurveyResponse.h"

const struct OHMSurveyResponseAttributes OHMSurveyResponseAttributes = {
	.locAccuracy = @"locAccuracy",
	.locLatitude = @"locLatitude",
	.locLongitude = @"locLongitude",
	.locTimestamp = @"locTimestamp",
	.submissionConfirmed = @"submissionConfirmed",
	.timestamp = @"timestamp",
	.userSubmitted = @"userSubmitted",
	.uuid = @"uuid",
};

const struct OHMSurveyResponseRelationships OHMSurveyResponseRelationships = {
	.promptResponses = @"promptResponses",
	.survey = @"survey",
	.user = @"user",
};

@implementation OHMSurveyResponseID
@end

@implementation _OHMSurveyResponse

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMSurveyResponse" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMSurveyResponse";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMSurveyResponse" inManagedObjectContext:moc_];
}

- (OHMSurveyResponseID*)objectID {
	return (OHMSurveyResponseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"locAccuracyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locAccuracy"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"locLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"locLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"submissionConfirmedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"submissionConfirmed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"userSubmittedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"userSubmitted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic locAccuracy;

- (double)locAccuracyValue {
	NSNumber *result = [self locAccuracy];
	return [result doubleValue];
}

- (void)setLocAccuracyValue:(double)value_ {
	[self setLocAccuracy:@(value_)];
}

- (double)primitiveLocAccuracyValue {
	NSNumber *result = [self primitiveLocAccuracy];
	return [result doubleValue];
}

- (void)setPrimitiveLocAccuracyValue:(double)value_ {
	[self setPrimitiveLocAccuracy:@(value_)];
}

@dynamic locLatitude;

- (double)locLatitudeValue {
	NSNumber *result = [self locLatitude];
	return [result doubleValue];
}

- (void)setLocLatitudeValue:(double)value_ {
	[self setLocLatitude:@(value_)];
}

- (double)primitiveLocLatitudeValue {
	NSNumber *result = [self primitiveLocLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLocLatitudeValue:(double)value_ {
	[self setPrimitiveLocLatitude:@(value_)];
}

@dynamic locLongitude;

- (double)locLongitudeValue {
	NSNumber *result = [self locLongitude];
	return [result doubleValue];
}

- (void)setLocLongitudeValue:(double)value_ {
	[self setLocLongitude:@(value_)];
}

- (double)primitiveLocLongitudeValue {
	NSNumber *result = [self primitiveLocLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLocLongitudeValue:(double)value_ {
	[self setPrimitiveLocLongitude:@(value_)];
}

@dynamic locTimestamp;

@dynamic submissionConfirmed;

- (BOOL)submissionConfirmedValue {
	NSNumber *result = [self submissionConfirmed];
	return [result boolValue];
}

- (void)setSubmissionConfirmedValue:(BOOL)value_ {
	[self setSubmissionConfirmed:@(value_)];
}

- (BOOL)primitiveSubmissionConfirmedValue {
	NSNumber *result = [self primitiveSubmissionConfirmed];
	return [result boolValue];
}

- (void)setPrimitiveSubmissionConfirmedValue:(BOOL)value_ {
	[self setPrimitiveSubmissionConfirmed:@(value_)];
}

@dynamic timestamp;

@dynamic userSubmitted;

- (BOOL)userSubmittedValue {
	NSNumber *result = [self userSubmitted];
	return [result boolValue];
}

- (void)setUserSubmittedValue:(BOOL)value_ {
	[self setUserSubmitted:@(value_)];
}

- (BOOL)primitiveUserSubmittedValue {
	NSNumber *result = [self primitiveUserSubmitted];
	return [result boolValue];
}

- (void)setPrimitiveUserSubmittedValue:(BOOL)value_ {
	[self setPrimitiveUserSubmitted:@(value_)];
}

@dynamic uuid;

@dynamic promptResponses;

- (NSMutableOrderedSet*)promptResponsesSet {
	[self willAccessValueForKey:@"promptResponses"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"promptResponses"];

	[self didAccessValueForKey:@"promptResponses"];
	return result;
}

@dynamic survey;

@dynamic user;

@end

@implementation _OHMSurveyResponse (PromptResponsesCoreDataGeneratedAccessors)
- (void)addPromptResponses:(NSOrderedSet*)value_ {
	[self.promptResponsesSet unionOrderedSet:value_];
}
- (void)removePromptResponses:(NSOrderedSet*)value_ {
	[self.promptResponsesSet minusOrderedSet:value_];
}
- (void)addPromptResponsesObject:(OHMSurveyPromptResponse*)value_ {
	[self.promptResponsesSet addObject:value_];
}
- (void)removePromptResponsesObject:(OHMSurveyPromptResponse*)value_ {
	[self.promptResponsesSet removeObject:value_];
}
- (void)insertObject:(OHMSurveyPromptResponse*)value inPromptResponsesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"promptResponses"];
}
- (void)removeObjectFromPromptResponsesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"promptResponses"];
}
- (void)insertPromptResponses:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"promptResponses"];
}
- (void)removePromptResponsesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"promptResponses"];
}
- (void)replaceObjectInPromptResponsesAtIndex:(NSUInteger)idx withObject:(OHMSurveyPromptResponse*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"promptResponses"];
}
- (void)replacePromptResponsesAtIndexes:(NSIndexSet *)indexes withPromptResponses:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"promptResponses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self promptResponses]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"promptResponses"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"promptResponses"];
}
@end

