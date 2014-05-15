// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.m instead.

#import "_OHMUser.h"

const struct OHMUserAttributes OHMUserAttributes = {
	.email = @"email",
	.fullName = @"fullName",
	.ohmID = @"ohmID",
	.password = @"password",
};

const struct OHMUserRelationships OHMUserRelationships = {
	.ohmlets = @"ohmlets",
	.reminderLocations = @"reminderLocations",
	.reminders = @"reminders",
	.surveyResponses = @"surveyResponses",
};

const struct OHMUserFetchedProperties OHMUserFetchedProperties = {
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
	

	return keyPaths;
}




@dynamic email;






@dynamic fullName;






@dynamic ohmID;






@dynamic password;






@dynamic ohmlets;

	
- (NSMutableOrderedSet*)ohmletsSet {
	[self willAccessValueForKey:@"ohmlets"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"ohmlets"];
  
	[self didAccessValueForKey:@"ohmlets"];
	return result;
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
	






@end
