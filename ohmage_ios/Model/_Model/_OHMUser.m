// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.m instead.

#import "_OHMUser.h"

const struct OHMUserAttributes OHMUserAttributes = {
	.email = @"email",
	.fullName = @"fullName",
	.isNewAccount = @"isNewAccount",
	.ohmID = @"ohmID",
	.password = @"password",
	.usesGoogleAuth = @"usesGoogleAuth",
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
	
	if ([key isEqualToString:@"isNewAccountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isNewAccount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"usesGoogleAuthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"usesGoogleAuth"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic email;






@dynamic fullName;






@dynamic isNewAccount;



- (BOOL)isNewAccountValue {
	NSNumber *result = [self isNewAccount];
	return [result boolValue];
}

- (void)setIsNewAccountValue:(BOOL)value_ {
	[self setIsNewAccount:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsNewAccountValue {
	NSNumber *result = [self primitiveIsNewAccount];
	return [result boolValue];
}

- (void)setPrimitiveIsNewAccountValue:(BOOL)value_ {
	[self setPrimitiveIsNewAccount:[NSNumber numberWithBool:value_]];
}





@dynamic ohmID;






@dynamic password;






@dynamic usesGoogleAuth;



- (BOOL)usesGoogleAuthValue {
	NSNumber *result = [self usesGoogleAuth];
	return [result boolValue];
}

- (void)setUsesGoogleAuthValue:(BOOL)value_ {
	[self setUsesGoogleAuth:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUsesGoogleAuthValue {
	NSNumber *result = [self primitiveUsesGoogleAuth];
	return [result boolValue];
}

- (void)setPrimitiveUsesGoogleAuthValue:(BOOL)value_ {
	[self setPrimitiveUsesGoogleAuth:[NSNumber numberWithBool:value_]];
}





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
