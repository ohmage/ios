// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *fullName;
	__unsafe_unretained NSString *isNewAccount;
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *useCellularData;
	__unsafe_unretained NSString *usesGoogleAuth;
} OHMUserAttributes;

extern const struct OHMUserRelationships {
	__unsafe_unretained NSString *ohmlets;
	__unsafe_unretained NSString *reminderLocations;
	__unsafe_unretained NSString *reminders;
	__unsafe_unretained NSString *surveyResponses;
} OHMUserRelationships;

extern const struct OHMUserFetchedProperties {
} OHMUserFetchedProperties;

@class OHMOhmlet;
@class OHMReminderLocation;
@class OHMReminder;
@class OHMSurveyResponse;









@interface OHMUserID : NSManagedObjectID {}
@end

@interface _OHMUser : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMUserID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fullName;



//- (BOOL)validateFullName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isNewAccount;



@property BOOL isNewAccountValue;
- (BOOL)isNewAccountValue;
- (void)setIsNewAccountValue:(BOOL)value_;

//- (BOOL)validateIsNewAccount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* useCellularData;



@property BOOL useCellularDataValue;
- (BOOL)useCellularDataValue;
- (void)setUseCellularDataValue:(BOOL)value_;

//- (BOOL)validateUseCellularData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* usesGoogleAuth;



@property BOOL usesGoogleAuthValue;
- (BOOL)usesGoogleAuthValue;
- (void)setUsesGoogleAuthValue:(BOOL)value_;

//- (BOOL)validateUsesGoogleAuth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *ohmlets;

- (NSMutableOrderedSet*)ohmletsSet;




@property (nonatomic, strong) NSSet *reminderLocations;

- (NSMutableSet*)reminderLocationsSet;




@property (nonatomic, strong) NSSet *reminders;

- (NSMutableSet*)remindersSet;




@property (nonatomic, strong) NSSet *surveyResponses;

- (NSMutableSet*)surveyResponsesSet;





@end

@interface _OHMUser (CoreDataGeneratedAccessors)

- (void)addOhmlets:(NSOrderedSet*)value_;
- (void)removeOhmlets:(NSOrderedSet*)value_;
- (void)addOhmletsObject:(OHMOhmlet*)value_;
- (void)removeOhmletsObject:(OHMOhmlet*)value_;

- (void)addReminderLocations:(NSSet*)value_;
- (void)removeReminderLocations:(NSSet*)value_;
- (void)addReminderLocationsObject:(OHMReminderLocation*)value_;
- (void)removeReminderLocationsObject:(OHMReminderLocation*)value_;

- (void)addReminders:(NSSet*)value_;
- (void)removeReminders:(NSSet*)value_;
- (void)addRemindersObject:(OHMReminder*)value_;
- (void)removeRemindersObject:(OHMReminder*)value_;

- (void)addSurveyResponses:(NSSet*)value_;
- (void)removeSurveyResponses:(NSSet*)value_;
- (void)addSurveyResponsesObject:(OHMSurveyResponse*)value_;
- (void)removeSurveyResponsesObject:(OHMSurveyResponse*)value_;

@end

@interface _OHMUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFullName;
- (void)setPrimitiveFullName:(NSString*)value;




- (NSNumber*)primitiveIsNewAccount;
- (void)setPrimitiveIsNewAccount:(NSNumber*)value;

- (BOOL)primitiveIsNewAccountValue;
- (void)setPrimitiveIsNewAccountValue:(BOOL)value_;




- (NSString*)primitiveOhmID;
- (void)setPrimitiveOhmID:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSNumber*)primitiveUseCellularData;
- (void)setPrimitiveUseCellularData:(NSNumber*)value;

- (BOOL)primitiveUseCellularDataValue;
- (void)setPrimitiveUseCellularDataValue:(BOOL)value_;




- (NSNumber*)primitiveUsesGoogleAuth;
- (void)setPrimitiveUsesGoogleAuth:(NSNumber*)value;

- (BOOL)primitiveUsesGoogleAuthValue;
- (void)setPrimitiveUsesGoogleAuthValue:(BOOL)value_;





- (NSMutableOrderedSet*)primitiveOhmlets;
- (void)setPrimitiveOhmlets:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitiveReminderLocations;
- (void)setPrimitiveReminderLocations:(NSMutableSet*)value;



- (NSMutableSet*)primitiveReminders;
- (void)setPrimitiveReminders:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSurveyResponses;
- (void)setPrimitiveSurveyResponses:(NSMutableSet*)value;


@end
