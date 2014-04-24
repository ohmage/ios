// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMOhmlet.m instead.

#import "_OHMOhmlet.h"

const struct OHMOhmletAttributes OHMOhmletAttributes = {
	.ohmID = @"ohmID",
	.ohmletDescription = @"ohmletDescription",
	.ohmletName = @"ohmletName",
};

const struct OHMOhmletRelationships OHMOhmletRelationships = {
	.surveys = @"surveys",
	.user = @"user",
};

const struct OHMOhmletFetchedProperties OHMOhmletFetchedProperties = {
};

@implementation OHMOhmletID
@end

@implementation _OHMOhmlet

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMOhmlet" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMOhmlet";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMOhmlet" inManagedObjectContext:moc_];
}

- (OHMOhmletID*)objectID {
	return (OHMOhmletID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic ohmID;






@dynamic ohmletDescription;






@dynamic ohmletName;






@dynamic surveys;

	
- (NSMutableSet*)surveysSet {
	[self willAccessValueForKey:@"surveys"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"surveys"];
  
	[self didAccessValueForKey:@"surveys"];
	return result;
}
	

@dynamic user;

	






@end
