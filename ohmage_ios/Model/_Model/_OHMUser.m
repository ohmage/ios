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
	






@end
