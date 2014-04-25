// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyItem.m instead.

#import "_OHMSurveyItem.h"

const struct OHMSurveyItemAttributes OHMSurveyItemAttributes = {
	.condition = @"condition",
	.defaultNumberResponse = @"defaultNumberResponse",
	.defaultStringResponse = @"defaultStringResponse",
	.displayLabel = @"displayLabel",
	.displayType = @"displayType",
	.itemType = @"itemType",
	.max = @"max",
	.maxChoices = @"maxChoices",
	.maxDimension = @"maxDimension",
	.maxDuration = @"maxDuration",
	.min = @"min",
	.minChoices = @"minChoices",
	.ohmID = @"ohmID",
	.skippable = @"skippable",
	.text = @"text",
	.wholeNumbersOnly = @"wholeNumbersOnly",
};

const struct OHMSurveyItemRelationships OHMSurveyItemRelationships = {
	.choices = @"choices",
	.responses = @"responses",
	.survey = @"survey",
};

const struct OHMSurveyItemFetchedProperties OHMSurveyItemFetchedProperties = {
};

@implementation OHMSurveyItemID
@end

@implementation _OHMSurveyItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMSurveyItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMSurveyItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMSurveyItem" inManagedObjectContext:moc_];
}

- (OHMSurveyItemID*)objectID {
	return (OHMSurveyItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"defaultNumberResponseValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"defaultNumberResponse"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"itemTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"max"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxChoicesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxChoices"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxDimensionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxDimension"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxDurationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxDuration"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"min"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minChoicesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minChoices"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"skippableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"skippable"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"wholeNumbersOnlyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"wholeNumbersOnly"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic condition;






@dynamic defaultNumberResponse;



- (double)defaultNumberResponseValue {
	NSNumber *result = [self defaultNumberResponse];
	return [result doubleValue];
}

- (void)setDefaultNumberResponseValue:(double)value_ {
	[self setDefaultNumberResponse:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveDefaultNumberResponseValue {
	NSNumber *result = [self primitiveDefaultNumberResponse];
	return [result doubleValue];
}

- (void)setPrimitiveDefaultNumberResponseValue:(double)value_ {
	[self setPrimitiveDefaultNumberResponse:[NSNumber numberWithDouble:value_]];
}





@dynamic defaultStringResponse;






@dynamic displayLabel;






@dynamic displayType;






@dynamic itemType;



- (int16_t)itemTypeValue {
	NSNumber *result = [self itemType];
	return [result shortValue];
}

- (void)setItemTypeValue:(int16_t)value_ {
	[self setItemType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveItemTypeValue {
	NSNumber *result = [self primitiveItemType];
	return [result shortValue];
}

- (void)setPrimitiveItemTypeValue:(int16_t)value_ {
	[self setPrimitiveItemType:[NSNumber numberWithShort:value_]];
}





@dynamic max;



- (double)maxValue {
	NSNumber *result = [self max];
	return [result doubleValue];
}

- (void)setMaxValue:(double)value_ {
	[self setMax:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveMaxValue {
	NSNumber *result = [self primitiveMax];
	return [result doubleValue];
}

- (void)setPrimitiveMaxValue:(double)value_ {
	[self setPrimitiveMax:[NSNumber numberWithDouble:value_]];
}





@dynamic maxChoices;



- (int16_t)maxChoicesValue {
	NSNumber *result = [self maxChoices];
	return [result shortValue];
}

- (void)setMaxChoicesValue:(int16_t)value_ {
	[self setMaxChoices:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMaxChoicesValue {
	NSNumber *result = [self primitiveMaxChoices];
	return [result shortValue];
}

- (void)setPrimitiveMaxChoicesValue:(int16_t)value_ {
	[self setPrimitiveMaxChoices:[NSNumber numberWithShort:value_]];
}





@dynamic maxDimension;



- (int32_t)maxDimensionValue {
	NSNumber *result = [self maxDimension];
	return [result intValue];
}

- (void)setMaxDimensionValue:(int32_t)value_ {
	[self setMaxDimension:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMaxDimensionValue {
	NSNumber *result = [self primitiveMaxDimension];
	return [result intValue];
}

- (void)setPrimitiveMaxDimensionValue:(int32_t)value_ {
	[self setPrimitiveMaxDimension:[NSNumber numberWithInt:value_]];
}





@dynamic maxDuration;



- (int32_t)maxDurationValue {
	NSNumber *result = [self maxDuration];
	return [result intValue];
}

- (void)setMaxDurationValue:(int32_t)value_ {
	[self setMaxDuration:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMaxDurationValue {
	NSNumber *result = [self primitiveMaxDuration];
	return [result intValue];
}

- (void)setPrimitiveMaxDurationValue:(int32_t)value_ {
	[self setPrimitiveMaxDuration:[NSNumber numberWithInt:value_]];
}





@dynamic min;



- (double)minValue {
	NSNumber *result = [self min];
	return [result doubleValue];
}

- (void)setMinValue:(double)value_ {
	[self setMin:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveMinValue {
	NSNumber *result = [self primitiveMin];
	return [result doubleValue];
}

- (void)setPrimitiveMinValue:(double)value_ {
	[self setPrimitiveMin:[NSNumber numberWithDouble:value_]];
}





@dynamic minChoices;



- (int16_t)minChoicesValue {
	NSNumber *result = [self minChoices];
	return [result shortValue];
}

- (void)setMinChoicesValue:(int16_t)value_ {
	[self setMinChoices:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMinChoicesValue {
	NSNumber *result = [self primitiveMinChoices];
	return [result shortValue];
}

- (void)setPrimitiveMinChoicesValue:(int16_t)value_ {
	[self setPrimitiveMinChoices:[NSNumber numberWithShort:value_]];
}





@dynamic ohmID;






@dynamic skippable;



- (BOOL)skippableValue {
	NSNumber *result = [self skippable];
	return [result boolValue];
}

- (void)setSkippableValue:(BOOL)value_ {
	[self setSkippable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSkippableValue {
	NSNumber *result = [self primitiveSkippable];
	return [result boolValue];
}

- (void)setPrimitiveSkippableValue:(BOOL)value_ {
	[self setPrimitiveSkippable:[NSNumber numberWithBool:value_]];
}





@dynamic text;






@dynamic wholeNumbersOnly;



- (BOOL)wholeNumbersOnlyValue {
	NSNumber *result = [self wholeNumbersOnly];
	return [result boolValue];
}

- (void)setWholeNumbersOnlyValue:(BOOL)value_ {
	[self setWholeNumbersOnly:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveWholeNumbersOnlyValue {
	NSNumber *result = [self primitiveWholeNumbersOnly];
	return [result boolValue];
}

- (void)setPrimitiveWholeNumbersOnlyValue:(BOOL)value_ {
	[self setPrimitiveWholeNumbersOnly:[NSNumber numberWithBool:value_]];
}





@dynamic choices;

	
- (NSMutableOrderedSet*)choicesSet {
	[self willAccessValueForKey:@"choices"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"choices"];
  
	[self didAccessValueForKey:@"choices"];
	return result;
}
	

@dynamic responses;

	
- (NSMutableSet*)responsesSet {
	[self willAccessValueForKey:@"responses"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"responses"];
  
	[self didAccessValueForKey:@"responses"];
	return result;
}
	

@dynamic survey;

	






@end
