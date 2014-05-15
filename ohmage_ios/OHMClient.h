//
//  OHMClient.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class OHMUser;
@class OHMOhmlet;
@class OHMSurvey;
@class OHMSurveyResponse;
@class OHMSurveyPromptResponse;
@class OHMReminder;
@class OHMReminderLocation;

@protocol OHMClientDelegate;

@interface OHMClient : AFHTTPSessionManager

+ (OHMClient*)sharedClient;

@property (nonatomic, weak) id<OHMClientDelegate> delegate;

- (void)saveClientState;

// Auth
- (BOOL)hasLoggedInUser;
- (OHMUser *)loggedInUser;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void (^)(BOOL success))completionBlock;
- (void)logout;

// HTTP
- (void)setAuthorizationToken:(NSString *)token;
- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *response, NSError *error))block;
- (void)submitSurveyResponse:(OHMSurveyResponse *)response;

// Model
- (NSOrderedSet *)ohmlets;
- (NSArray *)reminders;
- (NSArray *)reminderLocations;
- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet;
- (OHMReminder *)reminderWithOhmID:(NSString *)ohmID;
- (OHMReminderLocation *)insertNewReminderLocation;

// Core Data
- (OHMSurveyResponse *)buildResponseForSurvey:(OHMSurvey *)survey;
- (OHMReminder *)buildNewReminderForSurvey:(OHMSurvey *)survey;

- (void)deleteObject:(NSManagedObject *)object;
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                               sortKey:(NSString *)sortKey
                                                             predicate:(NSPredicate *)predicate
                                                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                             cacheName:(NSString *)cacheName;

@end

@protocol OHMClientDelegate <NSObject>

- (void)OHMClientDidUpdate:(OHMClient *)client;

@end