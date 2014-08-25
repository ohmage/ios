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
@class GTMOAuth2Authentication;
@class GPPSignIn;

@protocol OHMClientDelegate;

@interface OHMClient : AFHTTPSessionManager

+ (OHMClient*)sharedClient;

@property (nonatomic, weak) id<OHMClientDelegate> delegate;
@property (copy) void (^backgroundSessionCompletionHandler)();
@property (copy) void (^googleSignInCompletionBlock)(BOOL success, NSString *errorString);

@property (nonatomic, strong) NSURL *pendingInvitationURL;
@property (nonatomic, strong) GPPSignIn *gppSignIn;

//http://dev.ohmage.org/ohmage/ohmlets/114ceeab-4476-4e4c-8035-e4f1edf63818/invitation?ohmlet_invitation_id=256ed85f-4177-48d6-b7a9-f8cc159efaee

//http://dev.ohmage.org/ohmage/ohmlets/ad24a132-b4f9-4ba7-bd95-19f318c8d718/invitation?user_invitation_id=b5a12097-1616-487c-b08e-3766dd9668f9&email=forkishsound%40gmail.com&ohmlet_invitation_id=e12b77ff-f6d7-40ff-85af-e68a7e5b99f6


// user
- (void)saveClientState;
- (BOOL)hasLoggedInUser;
- (OHMUser *)loggedInUser;
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
       completionBlock:(void (^)(BOOL success, NSString *errorString))completionBlock;
- (void)loginWithGoogleAuth:(GTMOAuth2Authentication *)auth completionBlock:(void (^)(BOOL success))completionBlock;
- (void)createAccountWithName:(NSString *)name
                        email:(NSString *)email
                     password:(NSString *)password
              completionBlock:(void (^)(BOOL success, NSString *errorString))completionBlock;
- (void)logout;

- (void)handleOhmletInvitationURL:(NSURL *)url;

- (void)clearUserData;
- (void)submitSurveyResponse:(OHMSurveyResponse *)response;

// Model
- (NSOrderedSet *)ohmlets;
- (NSArray *)reminders;
- (NSArray *)timeReminders;
- (NSArray *)reminderLocations;
- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet;
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

@protocol OHMClientDelegate <NSObject>

- (void)OHMClientDidUpdate:(OHMClient *)client;

@end