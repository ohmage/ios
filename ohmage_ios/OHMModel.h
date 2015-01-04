//
//  OHMClient.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMUser;
@class OHMSurvey;
@class OHMSurveyResponse;
@class OHMSurveyPromptResponse;
@class OHMReminder;
@class OHMReminderLocation;

@protocol OHMModelDelegate;

@interface OHMModel : NSObject

+ (OHMModel*)sharedModel;

@property (nonatomic, weak) id<OHMModelDelegate> delegate;
@property (copy) void (^backgroundSessionCompletionHandler)();


// user
- (void)saveModelState;
- (BOOL)hasLoggedInUser;
- (OHMUser *)loggedInUser;
- (void)logout;

- (void)clearUserData;
- (void)submitSurveyResponse:(OHMSurveyResponse *)response;

// Model
- (void)fetchSurveysWithCompletionBlock:(void (^)())block;
- (NSArray *)reminders;
- (NSArray *)timeReminders;
- (NSArray *)reminderLocations;
- (NSArray *)surveys;
- (OHMReminder *)reminderWithOhmID:(NSString *)ohmID;
- (OHMReminderLocation *)insertNewReminderLocation;
- (OHMReminderLocation *)locationWithOhmID:(NSString *)ohmID;
- (OHMSurveyResponse *)buildResponseForSurvey:(OHMSurvey *)survey;
- (OHMReminder *)buildNewReminderForSurvey:(OHMSurvey *)survey;

// Core Data
- (void)deleteObject:(NSManagedObject *)object;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                               sortKey:(NSString *)sortKey
                                                             predicate:(NSPredicate *)predicate
                                                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                             cacheName:(NSString *)cacheName;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                       sortDescriptors:(NSArray *)sortDescriptors
                                                             predicate:(NSPredicate *)predicate
                                                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                             cacheName:(NSString *)cacheName;

@end

@protocol OHMModelDelegate <NSObject>

- (void)OHMModelDidUpdate:(OHMModel *)model;

@end