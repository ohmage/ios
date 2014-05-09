// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.m instead.

#import "_OHMSurveyResponse.h"

const struct OHMSurveyResponseAttributes OHMSurveyResponseAttributes = {
	.ohmID = @"ohmID",
	.submissionConfirmed = @"submissionConfirmed",
	.timestamp = @"timestamp",
	.userSubmitted = @"userSubmitted",
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




@dynamic ohmID;






@dynamic submissionConfirmed;



- (BOOL)submissionConfirmedValue {
	NSNumber *result = [self submissionConfirmed];
	return [result boolValue];
}

- (void)setSubmissionConfirmedValue:(BOOL)value_ {
	[self setSubmissionConfirmed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSubmissionConfirmedValue {
	NSNumber *result = [self primitiveSubmissionConfirmed];
	return [result boolValue];
}

- (void)setPrimitiveSubmissionConfirmedValue:(BOOL)value_ {
	[self setPrimitiveSubmissionConfirmed:[NSNumber numberWithBool:value_]];
}





@dynamic timestamp;






@dynamic userSubmitted;



- (BOOL)userSubmittedValue {
	NSNumber *result = [self userSubmitted];
	return [result boolValue];
}

- (void)setUserSubmittedValue:(BOOL)value_ {
	[self setUserSubmitted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUserSubmittedValue {
	NSNumber *result = [self primitiveUserSubmitted];
	return [result boolValue];
}

- (void)setPrimitiveUserSubmittedValue:(BOOL)value_ {
	[self setPrimitiveUserSubmitted:[NSNumber numberWithBool:value_]];
}





@dynamic promptResponses;

	
- (NSMutableOrderedSet*)promptResponsesSet {
	[self willAccessValueForKey:@"promptResponses"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"promptResponses"];
  
	[self didAccessValueForKey:@"promptResponses"];
	return result;
}
	

@dynamic survey;

	






@end
