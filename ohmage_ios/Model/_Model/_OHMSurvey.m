// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.m instead.

#import "_OHMSurvey.h"

const struct OHMSurveyAttributes OHMSurveyAttributes = {
	.isDue = @"isDue",
	.isLoaded = @"isLoaded",
	.ohmID = @"ohmID",
	.surveyDescription = @"surveyDescription",
	.surveyName = @"surveyName",
	.surveyVersion = @"surveyVersion",
};

const struct OHMSurveyRelationships OHMSurveyRelationships = {
	.ohmlet = @"ohmlet",
	.reminders = @"reminders",
	.surveyItems = @"surveyItems",
	.surveyResponses = @"surveyResponses",
};

const struct OHMSurveyFetchedProperties OHMSurveyFetchedProperties = {
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
	
	if ([key isEqualToString:@"isDueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isDue"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isLoadedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isLoaded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"surveyVersionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"surveyVersion"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic isDue;



- (BOOL)isDueValue {
	NSNumber *result = [self isDue];
	return [result boolValue];
}

- (void)setIsDueValue:(BOOL)value_ {
	[self setIsDue:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsDueValue {
	NSNumber *result = [self primitiveIsDue];
	return [result boolValue];
}

- (void)setPrimitiveIsDueValue:(BOOL)value_ {
	[self setPrimitiveIsDue:[NSNumber numberWithBool:value_]];
}





@dynamic isLoaded;



- (BOOL)isLoadedValue {
	NSNumber *result = [self isLoaded];
	return [result boolValue];
}

- (void)setIsLoadedValue:(BOOL)value_ {
	[self setIsLoaded:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsLoadedValue {
	NSNumber *result = [self primitiveIsLoaded];
	return [result boolValue];
}

- (void)setPrimitiveIsLoadedValue:(BOOL)value_ {
	[self setPrimitiveIsLoaded:[NSNumber numberWithBool:value_]];
}





@dynamic ohmID;






@dynamic surveyDescription;






@dynamic surveyName;






@dynamic surveyVersion;



- (int16_t)surveyVersionValue {
	NSNumber *result = [self surveyVersion];
	return [result shortValue];
}

- (void)setSurveyVersionValue:(int16_t)value_ {
	[self setSurveyVersion:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSurveyVersionValue {
	NSNumber *result = [self primitiveSurveyVersion];
	return [result shortValue];
}

- (void)setPrimitiveSurveyVersionValue:(int16_t)value_ {
	[self setPrimitiveSurveyVersion:[NSNumber numberWithShort:value_]];
}





@dynamic ohmlet;

	

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
