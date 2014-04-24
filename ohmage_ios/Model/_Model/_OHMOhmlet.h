// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OHMOhmlet.h instead.

#import <CoreData/CoreData.h>
#import "OHMObject.h"

extern const struct OHMOhmletAttributes {
	__unsafe_unretained NSString *ohmID;
	__unsafe_unretained NSString *ohmletDescription;
	__unsafe_unretained NSString *ohmletName;
} OHMOhmletAttributes;

extern const struct OHMOhmletRelationships {
	__unsafe_unretained NSString *surveys;
	__unsafe_unretained NSString *user;
} OHMOhmletRelationships;

extern const struct OHMOhmletFetchedProperties {
} OHMOhmletFetchedProperties;

@class OHMSurvey;
@class OHMUser;





@interface OHMOhmletID : NSManagedObjectID {}
@end

@interface _OHMOhmlet : OHMObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OHMOhmletID*)objectID;





@property (nonatomic, strong) NSString* ohmID;



//- (BOOL)validateOhmID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ohmletDescription;



//- (BOOL)validateOhmletDescription:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* ohmletName;



//- (BOOL)validateOhmletName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *surveys;

- (NSMutableSet*)surveysSet;




@property (nonatomic, strong) OHMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _OHMOhmlet (CoreDataGeneratedAccessors)

- (void)addSurveys:(NSSet*)value_;
- (void)removeSurveys:(NSSet*)value_;
- (void)addSurveysObject:(OHMSurvey*)value_;
- (void)removeSurveysObject:(OHMSurvey*)value_;

@end

@interface _OHMOhmlet (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveOhmID;
- (void)setPrimitiveOhmID:(NSString*)value;




- (NSString*)primitiveOhmletDescription;
- (void)setPrimitiveOhmletDescription:(NSString*)value;




- (NSString*)primitiveOhmletName;
- (void)setPrimitiveOhmletName:(NSString*)value;





- (NSMutableSet*)primitiveSurveys;
- (void)setPrimitiveSurveys:(NSMutableSet*)value;



- (OHMUser*)primitiveUser;
- (void)setPrimitiveUser:(OHMUser*)value;


@end
