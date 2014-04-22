// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurvey.m instead.

#import "_OHMSurvey.h"

const struct OHMSurveyAttributes OHMSurveyAttributes = {
	.surveyDescription = @"surveyDescription",
	.surveyId = @"surveyId",
	.surveyName = @"surveyName",
	.version = @"version",
};

const struct OHMSurveyRelationships OHMSurveyRelationships = {
	.ohmlet = @"ohmlet",
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
	
	if ([key isEqualToString:@"versionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"version"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic surveyDescription;






@dynamic surveyId;






@dynamic surveyName;






@dynamic version;



- (int16_t)versionValue {
	NSNumber *result = [self version];
	return [result shortValue];
}

- (void)setVersionValue:(int16_t)value_ {
	[self setVersion:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveVersionValue {
	NSNumber *result = [self primitiveVersion];
	return [result shortValue];
}

- (void)setPrimitiveVersionValue:(int16_t)value_ {
	[self setPrimitiveVersion:[NSNumber numberWithShort:value_]];
}





@dynamic ohmlet;

	

@dynamic surveyItems;

	
- (NSMutableSet*)surveyItemsSet {
	[self willAccessValueForKey:@"surveyItems"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"surveyItems"];
  
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
