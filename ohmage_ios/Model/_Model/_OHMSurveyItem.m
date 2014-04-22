// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyItem.m instead.

#import "_OHMSurveyItem.h"

const struct OHMSurveyItemAttributes OHMSurveyItemAttributes = {
	.condition = @"condition",
	.defaultResponse = @"defaultResponse",
	.displayLabel = @"displayLabel",
	.displayType = @"displayType",
	.itemId = @"itemId",
	.itemType = @"itemType",
	.max = @"max",
	.maxChoices = @"maxChoices",
	.maxDimension = @"maxDimension",
	.maxDuration = @"maxDuration",
	.min = @"min",
	.minChoices = @"minChoices",
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
	
	if ([key isEqualToString:@"itemTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemType"];
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






@dynamic defaultResponse;






@dynamic displayLabel;






@dynamic displayType;






@dynamic itemId;






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






@dynamic maxChoices;






@dynamic maxDimension;






@dynamic maxDuration;






@dynamic min;






@dynamic minChoices;






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

	

@dynamic responses;

	
- (NSMutableSet*)responsesSet {
	[self willAccessValueForKey:@"responses"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"responses"];
  
	[self didAccessValueForKey:@"responses"];
	return result;
}
	

@dynamic survey;

	






@end
