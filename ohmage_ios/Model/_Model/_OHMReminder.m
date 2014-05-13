// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMReminder.m instead.

#import "_OHMReminder.h"

const struct OHMReminderAttributes OHMReminderAttributes = {
	.alwaysShow = @"alwaysShow",
	.enabled = @"enabled",
	.endTime = @"endTime",
	.fireDate = @"fireDate",
	.isLocationReminder = @"isLocationReminder",
	.minimumReentryInterval = @"minimumReentryInterval",
	.ohmID = @"ohmID",
	.specificTime = @"specificTime",
	.startTime = @"startTime",
	.usesTimeRange = @"usesTimeRange",
	.weekdaysMask = @"weekdaysMask",
};

const struct OHMReminderRelationships OHMReminderRelationships = {
	.reminderLocation = @"reminderLocation",
	.survey = @"survey",
	.user = @"user",
};

const struct OHMReminderFetchedProperties OHMReminderFetchedProperties = {
};

@implementation OHMReminderID
@end

@implementation _OHMReminder

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OHMReminder" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OHMReminder";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OHMReminder" inManagedObjectContext:moc_];
}

- (OHMReminderID*)objectID {
	return (OHMReminderID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"alwaysShowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"alwaysShow"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"enabledValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"enabled"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isLocationReminderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isLocationReminder"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minimumReentryIntervalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minimumReentryInterval"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"usesTimeRangeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"usesTimeRange"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"weekdaysMaskValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"weekdaysMask"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic alwaysShow;



- (BOOL)alwaysShowValue {
	NSNumber *result = [self alwaysShow];
	return [result boolValue];
}

- (void)setAlwaysShowValue:(BOOL)value_ {
	[self setAlwaysShow:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAlwaysShowValue {
	NSNumber *result = [self primitiveAlwaysShow];
	return [result boolValue];
}

- (void)setPrimitiveAlwaysShowValue:(BOOL)value_ {
	[self setPrimitiveAlwaysShow:[NSNumber numberWithBool:value_]];
}





@dynamic enabled;



- (BOOL)enabledValue {
	NSNumber *result = [self enabled];
	return [result boolValue];
}

- (void)setEnabledValue:(BOOL)value_ {
	[self setEnabled:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveEnabledValue {
	NSNumber *result = [self primitiveEnabled];
	return [result boolValue];
}

- (void)setPrimitiveEnabledValue:(BOOL)value_ {
	[self setPrimitiveEnabled:[NSNumber numberWithBool:value_]];
}





@dynamic endTime;






@dynamic fireDate;






@dynamic isLocationReminder;



- (BOOL)isLocationReminderValue {
	NSNumber *result = [self isLocationReminder];
	return [result boolValue];
}

- (void)setIsLocationReminderValue:(BOOL)value_ {
	[self setIsLocationReminder:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsLocationReminderValue {
	NSNumber *result = [self primitiveIsLocationReminder];
	return [result boolValue];
}

- (void)setPrimitiveIsLocationReminderValue:(BOOL)value_ {
	[self setPrimitiveIsLocationReminder:[NSNumber numberWithBool:value_]];
}





@dynamic minimumReentryInterval;



- (int32_t)minimumReentryIntervalValue {
	NSNumber *result = [self minimumReentryInterval];
	return [result intValue];
}

- (void)setMinimumReentryIntervalValue:(int32_t)value_ {
	[self setMinimumReentryInterval:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMinimumReentryIntervalValue {
	NSNumber *result = [self primitiveMinimumReentryInterval];
	return [result intValue];
}

- (void)setPrimitiveMinimumReentryIntervalValue:(int32_t)value_ {
	[self setPrimitiveMinimumReentryInterval:[NSNumber numberWithInt:value_]];
}





@dynamic ohmID;






@dynamic specificTime;






@dynamic startTime;






@dynamic usesTimeRange;



- (BOOL)usesTimeRangeValue {
	NSNumber *result = [self usesTimeRange];
	return [result boolValue];
}

- (void)setUsesTimeRangeValue:(BOOL)value_ {
	[self setUsesTimeRange:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveUsesTimeRangeValue {
	NSNumber *result = [self primitiveUsesTimeRange];
	return [result boolValue];
}

- (void)setPrimitiveUsesTimeRangeValue:(BOOL)value_ {
	[self setPrimitiveUsesTimeRange:[NSNumber numberWithBool:value_]];
}





@dynamic weekdaysMask;



- (int16_t)weekdaysMaskValue {
	NSNumber *result = [self weekdaysMask];
	return [result shortValue];
}

- (void)setWeekdaysMaskValue:(int16_t)value_ {
	[self setWeekdaysMask:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveWeekdaysMaskValue {
	NSNumber *result = [self primitiveWeekdaysMask];
	return [result shortValue];
}

- (void)setPrimitiveWeekdaysMaskValue:(int16_t)value_ {
	[self setPrimitiveWeekdaysMask:[NSNumber numberWithShort:value_]];
}





@dynamic reminderLocation;

	

@dynamic survey;

	

@dynamic user;

	






@end
