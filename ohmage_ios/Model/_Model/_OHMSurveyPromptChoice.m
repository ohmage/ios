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
	.survetItemWithDefaults = @"survetItemWithDefaults",
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
	[self setIsDefault:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDefaultValue {
	NSNumber *result = [self primitiveIsDefault];
	return [result boolValue];
}

- (void)setPrimitiveIsDefaultValue:(BOOL)value_ {
	[self setPrimitiveIsDefault:[NSNumber numberWithBool:value_]];
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






@dynamic text;






@dynamic survetItemWithDefaults;

	

@dynamic surveyItem;

	






@end
