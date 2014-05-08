// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.m instead.

#import "_OHMSurveyResponse.h"

const struct OHMSurveyResponseAttributes OHMSurveyResponseAttributes = {
	.ohmID = @"ohmID",
	.submitted = @"submitted",
	.timestamp = @"timestamp",
};

const struct OHMSurveyResponseRelationships OHMSurveyResponseRelationships = {
	.promptResponses = @"promptResponses",
	.survey = @"survey",
};

const struct OHMSurveyResponseFetchedProperties OHMSurveyResponseFetchedProperties = {
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
	
	if ([key isEqualToString:@"submittedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"submitted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic ohmID;






@dynamic submitted;



- (BOOL)submittedValue {
	NSNumber *result = [self submitted];
	return [result boolValue];
}

- (void)setSubmittedValue:(BOOL)value_ {
	[self setSubmitted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSubmittedValue {
	NSNumber *result = [self primitiveSubmitted];
	return [result boolValue];
}

- (void)setPrimitiveSubmittedValue:(BOOL)value_ {
	[self setPrimitiveSubmitted:[NSNumber numberWithBool:value_]];
}





@dynamic timestamp;






@dynamic promptResponses;

	
- (NSMutableOrderedSet*)promptResponsesSet {
	[self willAccessValueForKey:@"promptResponses"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"promptResponses"];
  
	[self didAccessValueForKey:@"promptResponses"];
	return result;
}
	

@dynamic survey;

	






@end
