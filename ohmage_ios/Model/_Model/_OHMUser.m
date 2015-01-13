// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.m instead.

#import "_OHMUser.h"

const struct OHMUserAttributes OHMUserAttributes = {
	.email = @"email",
	.fullName = @"fullName",
	.useCellularData = @"useCellularData",
};

const struct OHMUserRelationships OHMUserRelationships = {
	.reminderLocations = @"reminderLocations",
	.reminders = @"reminders",
	.surveyResponses = @"surveyResponses",
	.surveys = @"surveys",
};

@implementation OHMUserID
@end

@implementation _OHMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMUser" inManagedObjectContext:moc_];
}

- (OHMUserID*)objectID {
	return (OHMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"useCellularDataValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"useCellularData"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic email;

@dynamic fullName;

@dynamic useCellularData;

- (BOOL)useCellularDataValue {
	NSNumber *result = [self useCellularData];
	return [result boolValue];
}

- (void)setUseCellularDataValue:(BOOL)value_ {
	[self setUseCellularData:@(value_)];
}

- (BOOL)primitiveUseCellularDataValue {
	NSNumber *result = [self primitiveUseCellularData];
	return [result boolValue];
}

- (void)setPrimitiveUseCellularDataValue:(BOOL)value_ {
	[self setPrimitiveUseCellularData:@(value_)];
}

@dynamic reminderLocations;

- (NSMutableSet*)reminderLocationsSet {
	[self willAccessValueForKey:@"reminderLocations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"reminderLocations"];

	[self didAccessValueForKey:@"reminderLocations"];
	return result;
}

@dynamic reminders;

- (NSMutableSet*)remindersSet {
	[self willAccessValueForKey:@"reminders"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"reminders"];

	[self didAccessValueForKey:@"reminders"];
	return result;
}

@dynamic surveyResponses;

- (NSMutableSet*)surveyResponsesSet {
	[self willAccessValueForKey:@"surveyResponses"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"surveyResponses"];

	[self didAccessValueForKey:@"surveyResponses"];
	return result;
}

@dynamic surveys;

- (NSMutableSet*)surveysSet {
	[self willAccessValueForKey:@"surveys"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"surveys"];

	[self didAccessValueForKey:@"surveys"];
	return result;
}

@end

