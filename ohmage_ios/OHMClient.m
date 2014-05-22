//
//  OHMClient.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMClient.h"
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "OHMUser.h"
#import "OHMOhmlet.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptChoice.h"
#import "OHMSurveyItemTypes.h"
#import "OHMSurveyResponse.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMReminder.h"
#import "OHMReminderLocation.h"
#import "OHMLocationManager.h"
#import "OHMReminderManager.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


@interface OHMClient () <GPPSignInDelegate>

// Core Data
@property(nonatomic, copy) NSURL *persistentStoreURL;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// HTTP
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, strong) AFHTTPSessionManager *backgroundSessionManager;

// Model
@property (nonatomic, strong) OHMUser *user;

@end

@implementation OHMClient

+ (OHMClient*)sharedClient
{
    static OHMClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kOhmageServerUrlString]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSMutableSet *contentTypes = [self.responseSerializer.acceptableContentTypes mutableCopy];
        [contentTypes addObject:@"text/plain"];
        self.responseSerializer.acceptableContentTypes = contentTypes;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
//        [[AFNetworkActivityLogger sharedLogger] startLogging];
        
        __weak OHMClient *weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf reachabilityStatusDidChange:status];
        }];
        [self.reachabilityManager startMonitoring];
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"OHMBackgroundSessionConfiguration"];
        self.backgroundSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL sessionConfiguration:config];
        self.backgroundSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *userID = [self persistentStoreMetadataTextForKey:@"loggedInUserID"];
        if (userID != nil) {
            self.user = [self userWithOhmID:userID];
            if (self.reachabilityManager.isReachable) {
                [self authenticateCurrentUser];
            }
        }
    }
    
    return self;
}

- (void)authenticateCurrentUser
{
    if (self.user.usesGoogleAuthValue) {
        [self refreshGoogleAuthentication];
    }
    else {
        [self loginWithEmail:self.user.email password:self.user.password completionBlock:nil];
    }
}

- (void)reachabilityStatusDidChange:(AFNetworkReachabilityStatus)status
{
//    NSLog(@"reachability status changed: %d", status);
    if (status > AFNetworkReachabilityStatusNotReachable && self.hasLoggedInUser) {
        [self authenticateCurrentUser];
    }
}

- (void)submitPendingSurveyResponses
{
    
    if (!self.reachabilityManager.reachableViaWiFi && !self.user.useCellularDataValue)
        return;
    
    NSArray *pendingResponses = [self pendingSurveyResponses];
    for (OHMSurveyResponse *response in pendingResponses) {
        NSLog(@"uploading pending response for survey: %@", response.survey.surveyName);
        [self uploadSurveyResponse:response];
    }
}

- (void)saveClientState
{
    NSLog(@"Saving client state");
    [self saveManagedContext];
}


#pragma mark - Auth

- (void)setUser:(OHMUser *)user
{
    _user = user;
    [self setPersistentStoreMetadataText:user.ohmID forKey:@"loggedInUserID"];
    NSLog(@"storing user id for logged in user: %@", user.ohmID);
}

- (BOOL)hasLoggedInUser
{
    return self.user != nil;
}

- (OHMUser *)loggedInUser
{
    return self.user;
}

- (void)refreshGoogleAuthentication
{
    GPPSignIn *googleSignIn = [GPPSignIn sharedInstance];
    googleSignIn.delegate = self;
    googleSignIn.clientID = kGoogleClientId;
    googleSignIn.attemptSSO = YES;
    BOOL success = [googleSignIn trySilentAuthentication];
    NSLog(@"silent google auth success: %d", success);
    if (!success) {
        [googleSignIn authenticate];
    }
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password completionBlock:(void (^)(BOOL success))completionBlock
{
    [self setAuthorizationToken:nil];
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"email": email, @"password" : password};
    
    [self getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Login Error");
        }
        else {
            NSLog(@"Login Success");
            
            self.authToken = [response authToken];
            self.refreshToken = [response refreshToken];
            [self setAuthorizationToken:self.authToken];
            
            if (self.hasLoggedInUser && self.user.isNewAccountValue) {
                self.user.ohmID = [response userID];
            }
            else {
                self.user = [self userWithOhmID:[response userID]];
            }
            
            self.user.email = email;
            self.user.password = password;
            self.user.isNewAccountValue = NO;
            
            [self refreshUserInfo];
            [self didLogin];
            
        }
        
        if (completionBlock) {
            completionBlock(error == nil);
        }
    }];
}

- (void)loginWithGoogleAuth:(GTMOAuth2Authentication *)auth completionBlock:(void (^)(BOOL success))completionBlock
{
    [self setAuthorizationToken:nil];
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"provider": @"google", @"access_token" : auth.accessToken};
    
    [self getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Google login Error");
            if (self.hasLoggedInUser) {
                if (completionBlock) {
                    completionBlock(NO);
                }
            }
            else {
                [self createAccountWithGoogleAuth:auth completionBlock:completionBlock];
            }
        }
        else {
            NSLog(@"Google login Success with response: %@", response);
            
            self.authToken = [response authToken];
            self.refreshToken = [response refreshToken];
            [self setAuthorizationToken:self.authToken];
            
            [self updateUserWithGoogleAuth:auth userID:response.userID];
            
            [self refreshUserInfo];
            [self didLogin];
            
            if (completionBlock) {
                completionBlock(YES);
            }
        }
    }];
}


- (void)createAccountWithName:(NSString *)name
                        email:(NSString *)email
                     password:(NSString *)password
              completionBlock:(void (^)(BOOL success))completionBlock
{
    [self setAuthorizationToken:nil];
    
    NSString *request =  [NSString stringWithFormat:@"people?password=%@", password];
    NSDictionary *json = @{@"email": email, @"full_name": name};
    
    [self postRequest:request withParameters:json completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"account create failed with error: %@", error);
        }
        else {
            NSLog(@"account create succeeded with response: %@", response);
            
            self.user = [self userWithOhmID:email];
            self.user.email = email;
            self.user.password = password;
            self.user.fullName = name;
            self.user.isNewAccountValue = YES;
            
        }
        if (completionBlock) {
            completionBlock(error == nil);
        }
    }];
}

- (void)createAccountWithGoogleAuth:(GTMOAuth2Authentication *)auth completionBlock:(void (^)(BOOL success))completionBlock
{
    NSString *request =  [NSString stringWithFormat:@"people?provider=google&access_token=%@", auth.accessToken];
    GTLPlusPerson *user = [GPPSignIn sharedInstance].googlePlusUser;
    NSString *email = auth.parameters[@"email"];
    NSDictionary *json = @{@"email": email, @"full_name": user.displayName};
    
    [self postRequest:request withParameters:json completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"google account create failed with error: %@", error);
        }
        else {
            NSLog(@"google account create succeeded with response: %@", response);
            [self updateUserWithGoogleAuth:auth userID:response.userID];
        }
        if (completionBlock) {
            completionBlock(error == nil);
        }
    }];
    
}

- (void)updateUserWithGoogleAuth:(GTMOAuth2Authentication *)auth userID:(NSString *)userID
{
    GTLPlusPerson *user = [GPPSignIn sharedInstance].googlePlusUser;
    NSString *email = auth.parameters[@"email"];
    
    self.user = [self userWithOhmID:email];
    self.user.email = email;
    self.user.fullName = user.displayName;
    self.user.usesGoogleAuthValue = YES;
    if (userID != nil) {
        self.user.ohmID = userID;
        self.user.isNewAccountValue = NO;
    }
    else {
        self.user.isNewAccountValue = YES;
    }
}

- (void)logout
{
    if (self.user.usesGoogleAuthValue) {
        [[GPPSignIn sharedInstance] signOut];
    }
    self.user = nil;
    [self.delegate OHMClientDidUpdate:self];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[OHMLocationManager sharedLocationManager] stopMonitoringAllRegions];
    [self saveClientState];
}

- (void)clearUserData
{
    NSLog(@"clearing user data");
    for (OHMSurveyResponse *response in self.user.surveyResponses ) {
        [self deleteObject:response];
    }
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    for (OHMReminder *reminder in self.user.reminders) {
        [self deleteObject:reminder];
    }
    
    [[OHMLocationManager sharedLocationManager] stopMonitoringAllRegions];
    for (OHMReminderLocation *location in self.user.reminderLocations) {
        [self deleteObject:location];
    }
    
    [self saveClientState];
}

- (void)didLogin
{
    if ([CLLocationManager locationServicesEnabled])
    {
        OHMLocationManager *appLocationManager = [OHMLocationManager sharedLocationManager];
        [appLocationManager.locationManager startUpdatingLocation];
    }
    
    [[OHMReminderManager sharedReminderManager] synchronizeReminders];
    [self submitPendingSurveyResponses];
}


#pragma mark - HTTP

- (void)setAuthorizationToken:(NSString *)token
{
//    NSLog(@"set auth token: %@", token);
    if (token) {
        [self.requestSerializer setValue:[@"ohmage " stringByAppendingString:token] forHTTPHeaderField:@"Authorization"];
    }
    else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    }
}

- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"GET %@ Succeeded", request);
        block((NSDictionary *)responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"GET %@ Failed", request);
        block(nil, error);
    }];
}

- (void)postRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *, NSError *))block
{
    [self POST:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"POST %@ Succeeded", request);
        block((NSDictionary *)responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"POST %@ Failed, task: %@, response: %@", request, task, task.response);
        block(nil, error);
    }];
}

- (void)buildResponseBodyForSurveyResponse:(OHMSurveyResponse *)surveyResponse
                              withFormData:(id<AFMultipartFormData>)formData
{
    
    NSDictionary *dataHeaders = @{@"Content-Disposition" :@"form-data; name=\"data\"",
                                  @"Content-Type" : @"application/json"};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:surveyResponse.JSON.jsonArray
                                                       options:0
                                                         error:nil];
    
    [formData appendPartWithHeaders:dataHeaders body:jsonData];
    
    for (OHMSurveyPromptResponse *promptResponse in surveyResponse.promptResponses) {
        if (promptResponse.hasMediaAttachment) {
            NSError *error = nil;
            [formData appendPartWithFileURL:promptResponse.mediaAttachmentURL
                                       name:@"media"
                                   fileName:promptResponse.mediaAttachmentName
                                   mimeType:promptResponse.mimeType
                                      error:&error];
            if (error != nil) {
                NSLog(@"error appending file: %@", error);
            }
        }
    }
}

- (void)handleCompletionForRequest:(NSURLRequest *)request
                 forSurveyResponse:(OHMSurveyResponse *)surveyResponse
                         withError:(NSError *)error
{
    if (error != nil) {
        NSLog(@"error creating new request");
    }
    else {
        NSLog(@"user cell: %d, request cell: %d", self.user.useCellularDataValue, request.allowsCellularAccess);
        NSURLSessionUploadTask *task =
        [self.backgroundSessionManager uploadTaskWithRequest:request
                                                    fromFile:surveyResponse.tempFileURL
                                                    progress:nil
                                           completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
        {
           if (error != nil) {
               NSLog(@"Submit survey failure with error: %@", error);
           }
           else {
//               NSLog(@"submit survey success with response: %@", responseObject);
               if (![responseObject isKindOfClass:[NSArray class]]) {
                   NSLog(@"Submitted survey response is not an array");
                   return;
               }
               NSArray *responseArray = (NSArray *)responseObject;
               NSDictionary *returnedSurveyResponseDef = [responseArray firstObject];
               NSString *ohmId = returnedSurveyResponseDef.surveyResponseMetadata.surveyResponseID;
               if ([surveyResponse.ohmID isEqualToString:ohmId]) {
                   NSLog(@"Submission confirmed for survey: %@", surveyResponse.survey.surveyName);
                   surveyResponse.submissionConfirmedValue = YES;
                   [self saveClientState];
               }
           }
       }];
        
        [task resume];
        
        [self saveClientState];
    }
}

- (void)uploadSurveyResponse:(OHMSurveyResponse *)surveyResponse
{
    NSError *requestError = nil;
    NSString *requestString = [kOhmageServerUrlString stringByAppendingPathComponent:surveyResponse.uploadRequestUrlString];
    
    NSMutableURLRequest *request =
    [self.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                 URLString:requestString
                                                parameters:nil
                                 constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [self buildResponseBodyForSurveyResponse:surveyResponse
                                     withFormData:formData];
     }
                                                     error:&requestError];
    
    if (requestError != nil) {
        NSLog(@"Error creating request: %@", requestError);
        return;
    }
    
    request.allowsCellularAccess = self.user.useCellularDataValue;
    request = [self.backgroundSessionManager.requestSerializer requestWithMultipartFormRequest:request
                                                                   writingStreamContentsToFile:surveyResponse.tempFileURL
                                                                             completionHandler:^(NSError *error)
       {
           [self handleCompletionForRequest:request forSurveyResponse:surveyResponse withError:error];
       }];
}

- (void)submitSurveyResponse:(OHMSurveyResponse *)surveyResponse
{
    surveyResponse.timestamp = [NSDate date];
    surveyResponse.userSubmittedValue = YES;
    surveyResponse.survey.isDueValue = NO;
    if ([OHMLocationManager sharedLocationManager].hasLocation) {
        CLLocation *location = [OHMLocationManager sharedLocationManager].location;
        surveyResponse.locLongitudeValue = location.coordinate.longitude;
        surveyResponse.locLatitudeValue = location.coordinate.latitude;
        surveyResponse.locAccuracyValue = location.horizontalAccuracy;
        surveyResponse.locTimestamp = location.timestamp;
    }
    
    [self saveClientState];
    
    if (self.reachabilityManager.isReachable) {
        [self uploadSurveyResponse:surveyResponse];
    }

}

- (void)refreshUserInfo
{
    [self getRequest:[self.user definitionRequestUrlString]
      withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
          
          if (error) {
              NSLog(@"Refresh user info Error");
          }
          else {
              NSLog(@"Refresh user info Success");
              
              self.user.fullName = [response userFullName];
              
              [self refreshOhmlets:[response ohmlets]];
              
              [self.delegate OHMClientDidUpdate:self];
              [self saveClientState];
          }
      }];
}

- (void)refreshOhmlets:(NSArray *)ohmletDefinitions
{
    NSMutableOrderedSet *ohmlets = [NSMutableOrderedSet orderedSetWithCapacity:[ohmletDefinitions count]];
    for (NSDictionary *ohmletDefinition in ohmletDefinitions) {
        OHMOhmlet *ohmlet = [self ohmletWithOhmID:[ohmletDefinition ohmletID]];
        [self refreshOhmletInfo:ohmlet];
        [self refreshSurveys:[ohmletDefinition surveyDefinitions] forOhmlet:ohmlet];
        [ohmlets addObject:ohmlet];
    }
    self.user.ohmlets = ohmlets;
}

- (void)refreshOhmletInfo:(OHMOhmlet *)ohmlet
{
    [self getRequest:[ohmlet definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error updating ohmlet: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"got ohmlet: %@, id: %@", [response ohmletName], [response ohmletID]);
            ohmlet.ohmletName = [response ohmletName];
            ohmlet.ohmletDescription = [response ohmletDescription];
            [self.delegate OHMClientDidUpdate:self];
            [self saveClientState];
            if (ohmlet.ohmletUpdatedBlock) {
                ohmlet.ohmletUpdatedBlock();
            }
        }
    }];
}

- (void)refreshSurveys:(NSArray *)surveyDefinitions forOhmlet:(OHMOhmlet *)ohmlet
{
    NSMutableSet *surveys = [NSMutableSet setWithCapacity:[surveyDefinitions count]];
    int index = 0;
    for (NSDictionary *surveyDefinition in surveyDefinitions) {
        OHMSurvey * survey = [self surveyWithOhmID:[surveyDefinition surveyID] andVersion:[surveyDefinition surveyVersion]];
        survey.indexValue = index++;
        if (!survey.isLoadedValue) {
            [self loadSurveyFromServer:survey];
        }
        [surveys addObject:survey];
    }
    ohmlet.surveys = surveys;
}

- (void)loadSurveyFromServer:(OHMSurvey *)survey
{
    [self getRequest:[survey definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error updating survey: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"got survey: %@, version: %ld", [response surveyName], (long)[response surveyVersion]);
            survey.surveyName = [response surveyName];
            survey.surveyDescription = [response surveyDescription];
            [self createSurveyItems:[response surveyItems] forSurvey:survey];
            survey.isLoadedValue = YES;
            [self saveClientState];
            if (survey.surveyUpdatedBlock) {
                survey.surveyUpdatedBlock();
            }
        }
    }];
}

- (void)createSurveyItems:(NSArray *)itemDefinitions forSurvey:(OHMSurvey *)survey
{
    NSMutableOrderedSet *surveyItems = [NSMutableOrderedSet orderedSetWithCapacity:[itemDefinitions count]];
    for (NSDictionary *itemDefinition in itemDefinitions) {
        OHMSurveyItem *item = [self insertNewSurveyItem];
        [item setValuesFromDefinition:itemDefinition];
        [self createChoicesForSurveyItem:item withDefinition:itemDefinition];
        [surveyItems addObject:item];
    }
    survey.surveyItems = surveyItems;
}

- (void)createChoicesForSurveyItem:(OHMSurveyItem *)surveyItem withDefinition:(NSDictionary *)itemDefinition
{
    NSArray *choiceDefinitions = [itemDefinition surveyItemChoices];
    if (choiceDefinitions == nil) return;
    
    NSArray *defaultChoices = [itemDefinition surveyItemDefaultChoiceValues];
    
    for (NSDictionary *choiceDefinition in choiceDefinitions) {
        OHMSurveyPromptChoice *promptChoice = (OHMSurveyPromptChoice *)[self insertNewObjectForEntityForName:[OHMSurveyPromptChoice entityName]];
        promptChoice.surveyItem = surveyItem;
        promptChoice.text = [choiceDefinition surveyPromptChoiceText];
        switch (surveyItem.itemTypeValue) {
            case OHMSurveyItemTypeNumberSingleChoicePrompt:
            case OHMSurveyItemTypeNumberMultiChoicePrompt:
                promptChoice.numberValue = [choiceDefinition surveyPromptChoiceNumberValue];
                if ([defaultChoices containsObject:promptChoice.numberValue]) {
                    promptChoice.isDefaultValue = YES;
                }
                break;
            case OHMSurveyItemTypeStringSingleChoicePrompt:
            case OHMSurveyItemTypeStringMultiChoicePrompt:
                promptChoice.stringValue = [choiceDefinition surveyPromptChoiceStringValue];
                if ([defaultChoices containsObject:promptChoice.stringValue]) {
                    promptChoice.isDefaultValue = YES;
                }
                break;
            default:
                NSLog(@"item type: %d", surveyItem.itemTypeValue);
                NSAssert(0, @"Can't parse value for choice: %@", choiceDefinition);
                break;
        }
    }
}

#pragma mark - Property Accessors (Core Data)

/**
 *  persistentStoreURL
 */
- (NSURL *)persistentStoreURL {
    if (_persistentStoreURL == nil) {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories firstObject];
        NSString *path = [documentDirectory stringByAppendingPathComponent:@"Ohmage.data"];
        _persistentStoreURL = [NSURL fileURLWithPath:path];
    }
    
    return _persistentStoreURL;
}

/**
 *  managedObjectContext
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setUndoManager:nil];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

/**
 *  managedObjectModel
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

/**
 *  persistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            NSLog(@"Error opening persistant store %@, %@", error, [error userInfo]);
//            abort();
            [self resetClient];
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSString *)persistentStoreMetadataTextForKey:(NSString *)key
{
    NSPersistentStore *store = [self.persistentStoreCoordinator persistentStoreForURL:self.persistentStoreURL];
    NSDictionary *metadata = [self.persistentStoreCoordinator metadataForPersistentStore:store];
    return metadata[key];
}

- (void)setPersistentStoreMetadataText:(NSString *)text forKey:(NSString *)key
{
//    NSLog(@"set store metadata text: %@ for key: %@", text, key);
    NSPersistentStore *store = [self.persistentStoreCoordinator persistentStoreForURL:self.persistentStoreURL];
    NSMutableDictionary *metadata = [[self.persistentStoreCoordinator metadataForPersistentStore:store] mutableCopy];
    if (text) {
        metadata[key] = text;
    }
    else {
        [metadata removeObjectForKey:key];
    }
    [self.persistentStoreCoordinator setMetadata:metadata forPersistentStore:store];
}


#pragma mark - Core Data (public)

- (NSOrderedSet *)ohmlets
{
    return self.user.ohmlets;
}

- (NSArray *)reminders
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"specificTime" ascending:NO];
    return [self.user.reminders sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)timeReminders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocationReminder != YES"];
    return [[self reminders] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)reminderLocations
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    return [self.user.reminderLocations sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"surveyName" ascending:YES];
    return [ohmlet.surveys sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSArray *)pendingSurveyResponses
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userSubmitted == YES AND submissionConfirmed == NO"];
    return [self fetchManagedObjectsWithEntityName:[OHMSurveyResponse entityName] predicate:predicate sortDescriptors:nil fetchLimit:0];
}

- (OHMReminder *)reminderWithOhmID:(NSString *)ohmId
{
    return (OHMReminder *)[self fetchObjectForEntityName:[OHMReminder entityName] withUniqueOhmID:ohmId create:NO];
}



- (OHMSurveyResponse *)buildResponseForSurvey:(OHMSurvey *)survey
{
    OHMSurveyResponse *response = [self insertNewSurveyResponse];
    response.survey = survey;
    response.user = self.user;
    
    for (OHMSurveyItem *item in survey.surveyItems) {
        OHMSurveyPromptResponse *promptResponse = [self insertNewSurveyPromptResponse];
        promptResponse.surveyItem = item;
        promptResponse.surveyResponse = response;
        if (item.hasDefaultResponse) {
            [promptResponse initializeDefaultResonse];
        }
    }
    
    return response;
}

- (OHMReminder *)buildNewReminderForSurvey:(OHMSurvey *)survey
{
    OHMReminder *reminder = (OHMReminder *)[self insertNewObjectForEntityForName:[OHMReminder entityName]];
    reminder.survey = survey;
    reminder.user = self.user;
    reminder.weekdaysMaskValue = OHMRepeatDayEveryday;
    reminder.enabledValue = YES;
    return reminder;
}

- (OHMReminderLocation *)insertNewReminderLocation
{
    OHMReminderLocation *location = (OHMReminderLocation *)[self insertNewObjectForEntityForName:[OHMReminderLocation entityName]];
    location.user = self.user;
    return location;
}


- (OHMReminderLocation *)locationWithOhmID:(NSString *)ohmId
{
    return (OHMReminderLocation *)[self fetchObjectForEntityName:[OHMReminderLocation entityName] withUniqueOhmID:ohmId create:NO];
}


#pragma mark - Core Data (private)

- (OHMUser *)userWithOhmID:(NSString *)ohmID
{
    return (OHMUser *)[self fetchObjectForEntityName:[OHMUser entityName] withUniqueOhmID:ohmID create:YES];
}

- (OHMOhmlet *)ohmletWithOhmID:(NSString *)ohmID
{
    return (OHMOhmlet *)[self fetchObjectForEntityName:[OHMOhmlet entityName] withUniqueOhmID:ohmID create:YES];
}

- (OHMSurvey *)surveyWithOhmID:(NSString *)ohmID andVersion:(int16_t)version
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ohmID == %@) AND (surveyVersion == %d)", ohmID, version];
    OHMSurvey *survey = (OHMSurvey *)[self fetchObjectForEntityName:[OHMSurvey entityName] withUniquePredicate:predicate create:YES];
    survey.ohmID = ohmID;
    survey.surveyVersionValue = version;
    return survey;
}

- (OHMSurveyItem *)insertNewSurveyItem
{
    OHMSurveyItem *newItem = (OHMSurveyItem *)[self insertNewObjectForEntityForName:[OHMSurveyItem entityName]];
    return newItem;
}

- (OHMSurveyResponse *)insertNewSurveyResponse
{
    return (OHMSurveyResponse *)[self insertNewObjectForEntityForName:[OHMSurveyResponse entityName]];
}

- (OHMSurveyPromptResponse *)insertNewSurveyPromptResponse
{
    return (OHMSurveyPromptResponse *)[self insertNewObjectForEntityForName:[OHMSurveyPromptResponse entityName]];
}

- (OHMObject *)fetchObjectForEntityName:(NSString *)entityName withUniqueOhmID:(NSString *)ohmID create:(BOOL)create
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ohmID == %@", ohmID];
    OHMObject *object = (OHMObject *)[self fetchObjectForEntityName:entityName withUniquePredicate:predicate create:create];
    object.ohmID = ohmID;
    return object;
}

- (NSManagedObject *)fetchObjectForEntityName:(NSString *)entityName withUniquePredicate:(NSPredicate *)predicate create:(BOOL)create
{
//    NSLog(@"fetch or insert entity: %@ with predicate: %@", entityName, [predicate debugDescription]);
    NSArray *results = [self allObjectsWithEntityName:entityName sortKey:nil predicate:predicate ascending:NO];
    
    if ([results count]) {
        NSAssert([results count] == 1, @"More than one object with predicate: %@", [predicate debugDescription]);
//        NSLog(@"Returning existing entity: %@ for predicate: %@", entityName, [predicate debugDescription]);
        return [results firstObject];
    }
    else {
        return [self insertNewObjectForEntityForName:entityName];
    }
}

/**
 *  insertNewObjectForEntityForName:withValues
 */
- (NSManagedObject *)insertNewObjectForEntityForName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:self.managedObjectContext];
}

/**
 *  allObjectsWithEntityName:sortKey:predicate:ascending
 */
- (NSArray *)allObjectsWithEntityName:(NSString *)entityName sortKey:(NSString *)sortKey predicate:(NSPredicate *)predicate ascending:(BOOL)ascending {
    NSArray *descriptors = nil;
    
    if (sortKey != nil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    }
    
    NSArray *objects = [self fetchManagedObjectsWithEntityName:entityName predicate:predicate sortDescriptors:descriptors fetchLimit:0];
    
    return objects;
}

/**
 *  fetchManagedObjectsWithEntityName:predicate:sortDescriptors
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                     predicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors
                                    fetchLimit:(NSUInteger)fetchLimit {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        
#ifdef DEBUG
        [NSException raise:@"Fetch failed"
                    format:@"Reason: %@", [error localizedDescription]];
#endif
        
        // If there was an error, then just return an empty array.
        // (I'll probably regret this decision at some point down the road...)
        return [NSArray array];
    }
    
    return fetchedObjects;
}

/**
 *  fetchedResultsControllerWithEntityName:sortKey:cacheName
 */
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                               sortKey:(NSString *)sortKey
                                                             predicate:(NSPredicate *)predicate
                                                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                             cacheName:(NSString *)cacheName
{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    
    return [self fetchedResultsControllerWithEntityName:entityName
                                               sortDescriptors:@[sortDescriptor]
                                              predicate:predicate
                                     sectionNameKeyPath:sectionNameKeyPath
                                              cacheName:cacheName];
}


/**
 *  fetchedResultsControllerWithEntityName:sortKey:cacheName
 */
- (NSFetchedResultsController *)fetchedResultsControllerWithEntityName:(NSString *)entityName
                                                       sortDescriptors:(NSArray *)sortDescriptors
                                                             predicate:(NSPredicate *)predicate
                                                    sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                             cacheName:(NSString *)cacheName
{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:20];
    
    // Build a fetch results controller based on the above fetch request.
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:sectionNameKeyPath
                                                                                                          cacheName:cacheName];
    
    
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    if (success == NO) {
        // Not sure if we should return the 'dead' controller or just return 'nil'...
        // [fetchedResultsController setDelegate:nil];
        // [fetchedResultsController release];
        // fetchedResultsController = nil;
    }
    
    return fetchedResultsController;
}

/**
 *  saveManagedContext
 */
- (void)saveManagedContext {
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Error saving context: %@", [error localizedDescription]);
    }
}

/**
 *  deleteObject
 */
- (void)deleteObject:(NSManagedObject *)object {
    [self.managedObjectContext deleteObject:object];
}

/**
 *  deletePersistentStore
 */
- (void)deletePersistentStore {
    NSLog(@"Deleting persistent store.");
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:self.persistentStoreURL error:nil];
    
    self.persistentStoreURL = nil;
}

- (void)resetClient
{
    [self deletePersistentStore];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[OHMLocationManager sharedLocationManager] stopMonitoringAllRegions];
}



#pragma mark - Google Login Delegate

- (void)showGoogleLoginFailureAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Google Authentication Failed" message:@"You have been logged out because your google account failed to authenticate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Client received google error %@ and auth object %@",error, auth);
    if (error) {
//        [self showGoogleLoginFailureAlert];
    }
    else {
        [self loginWithGoogleAuth:auth completionBlock:^(BOOL success) {
            if (!success) {
                [self showGoogleLoginFailureAlert];
            }
        }];
    }
}

@end
