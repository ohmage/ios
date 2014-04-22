// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMSurveyResponse.m instead.

#import "_OHMSurveyResponse.h"

const struct OHMSurveyResponseAttributes OHMSurveyResponseAttributes = {
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
	

	return keyPaths;
}




@dynamic promptResponses;

	
- (NSMutableSet*)promptResponsesSet {
	[self willAccessValueForKey:@"promptResponses"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"promptResponses"];
  
	[self didAccessValueForKey:@"promptResponses"];
	return result;
}
	

@dynamic survey;

	






@end
