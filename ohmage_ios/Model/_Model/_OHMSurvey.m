// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.m instead.

#import "_OHMSurvey.h"

const struct OHMSurveyAttributes OHMSurveyAttributes = {
	.index = @"index",
	.isDue = @"isDue",
	.schemaName = @"schemaName",
	.schemaVersion = @"schemaVersion",
	.surveyDescription = @"surveyDescription",
	.surveyName = @"surveyName",
};

const struct OHMSurveyRelationships OHMSurveyRelationships = {
	.reminders = @"reminders",
	.surveyItems = @"surveyItems",
	.surveyResponses = @"surveyResponses",
};

@implementation OHMSurveyID
@end

@implementation _OHMSurvey

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMSurvey" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMSurvey";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMSurvey" inManagedObjectContext:moc_];
}

- (OHMSurveyID*)objectID {
	return (OHMSurveyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isDueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic index;

- (int16_t)indexValue {
	NSNumber *result = [self index];
	return [result shortValue];
}

- (void)setIndexValue:(int16_t)value_ {
	[self setIndex:@(value_)];
}

- (int16_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result shortValue];
}

- (void)setPrimitiveIndexValue:(int16_t)value_ {
	[self setPrimitiveIndex:@(value_)];
}

@dynamic isDue;

- (BOOL)isDueValue {
	NSNumber *result = [self isDue];
	return [result boolValue];
}

- (void)setIsDueValue:(BOOL)value_ {
	[self setIsDue:@(value_)];
}

- (BOOL)primitiveIsDueValue {
	NSNumber *result = [self primitiveIsDue];
	return [result boolValue];
}

- (void)setPrimitiveIsDueValue:(BOOL)value_ {
	[self setPrimitiveIsDue:@(value_)];
}

@dynamic schemaName;

@dynamic schemaVersion;

@dynamic surveyDescription;

@dynamic surveyName;

@dynamic reminders;

- (NSMutableSet*)remindersSet {
	[self willAccessValueForKey:@"reminders"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"reminders"];

	[self didAccessValueForKey:@"reminders"];
	return result;
}

@dynamic surveyItems;

- (NSMutableOrderedSet*)surveyItemsSet {
	[self willAccessValueForKey:@"surveyItems"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"surveyItems"];

	[self didAccessValueForKey:@"surveyItems"];
	return result;
}

@dynamic surveyResponses;

- (NSMutableSet*)surveyResponsesSet {
	[self willAccessValueForKey:@"surveyResponses"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"surveyResponses"];

	[self didAccessValueForKey:@"surveyResponses"];
	return result;
}

@end

@implementation _OHMSurvey (SurveyItemsCoreDataGeneratedAccessors)
- (void)addSurveyItems:(NSOrderedSet*)value_ {
	[self.surveyItemsSet unionOrderedSet:value_];
}
- (void)removeSurveyItems:(NSOrderedSet*)value_ {
	[self.surveyItemsSet minusOrderedSet:value_];
}
- (void)addSurveyItemsObject:(OHMSurveyItem*)value_ {
	[self.surveyItemsSet addObject:value_];
}
- (void)removeSurveyItemsObject:(OHMSurveyItem*)value_ {
	[self.surveyItemsSet removeObject:value_];
}
- (void)insertObject:(OHMSurveyItem*)value inSurveyItemsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"surveyItems"];
}
- (void)removeObjectFromSurveyItemsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"surveyItems"];
}
- (void)insertSurveyItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"surveyItems"];
}
- (void)removeSurveyItemsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"surveyItems"];
}
- (void)replaceObjectInSurveyItemsAtIndex:(NSUInteger)idx withObject:(OHMSurveyItem*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"surveyItems"];
}
- (void)replaceSurveyItemsAtIndexes:(NSIndexSet *)indexes withSurveyItems:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"surveyItems"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self surveyItems]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"surveyItems"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"surveyItems"];
}
@end

