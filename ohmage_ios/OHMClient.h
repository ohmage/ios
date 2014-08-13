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

//ohmage://dev.ohmage.org/ohmage/ohmlets/eb1592a3-0bb1-42d6-8fe3-46fb38e24dd0/invitation?ohmlet_invitation_id=9ba4b0e9-1ebd-4159-8a65-9044ed6508c1
//ohmage://dev.ohmage.org/ohmage/ohmlets/319762c2-8b24-46a9-9a5d-49b797f42b6d/invitation?ohmlet_invitation_id=f978d913-cd18-4654-9d84-1db10d2f8a6f
//ohmage://dev.ohmage.org/ohmage/ohmlets/beb0bd48-cd9c-49ca-9c12-e751b51dd15b/invitation?user_invitation_id=f95ee405-e64a-4373-9005-350055295a31&email=cforkish%40ccrma.stanford.edu&ohmlet_invitation_id=59b86337-e2c1-48b7-8f74-e543766d7c80


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