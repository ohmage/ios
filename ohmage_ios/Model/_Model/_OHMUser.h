// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMUser.h instead.

#import <CoreData/CoreData.h>


extern const struct OHMUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *fullName;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *userId;
} OHMUserAttributes;

extern const struct OHMUserRelationships {
	__unsafe_unretained NSString *ohmlets;
} OHMUserRelationships;

extern const struct OHMUserFetchedProperties {
} OHMUserFetchedProperties;

@class OHMOhmlet;






@interface OHMUserID : NSManagedObjectID {}
@end

@interface _OHMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMUserID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* fullName;



//- (BOOL)validateFullName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* userId;



//- (BOOL)validateUserId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *ohmlets;

- (NSMutableSet*)ohmletsSet;





@end

@interface _OHMUser (CoreDataGeneratedAccessors)

- (void)addOhmlets:(NSSet*)value_;
- (void)removeOhmlets:(NSSet*)value_;
- (void)addOhmletsObject:(OHMOhmlet*)value_;
- (void)removeOhmletsObject:(OHMOhmlet*)value_;

@end

@interface _OHMUser (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitiveFullName;
- (void)setPrimitiveFullName:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSString*)primitiveUserId;
- (void)setPrimitiveUserId:(NSString*)value;





- (NSMutableSet*)primitiveOhmlets;
- (void)setPrimitiveOhmlets:(NSMutableSet*)value;


@end
