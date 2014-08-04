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
#import "HMFJSONResponseSerializerWithData.h"
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


static NSString * const kResponseErrorStringKey = @"ResponseErrorString";


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

@property (nonatomic, copy) NSDate *lastRefresh;

// Model
@property (nonatomic, strong) OHMUser *user;

@end

@implementation OHMClient

/**
 *  sharedClient
 */
+ (OHMClient*)sharedClient
{
    static OHMClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kOhmageServerUrlString]];
    });
    
    return _sharedClient;
}

/**
 *  initWithBaseURL
 */
- (instancetype)initWithBaseURL:(NSURL *)url
{
    // client is subclass of AFHTTPSessionManager
    // initializing with base URL allows us to use relative paths for requests
    self = [super initWithBaseURL:url];
    
    if (self) {
        // setup serializers
        self.responseSerializer = [HMFJSONResponseSerializerWithData serializerWithReadingOptions:NSJSONReadingAllowFragments];
        NSMutableSet *contentTypes = [self.responseSerializer.acceptableContentTypes mutableCopy];
        [contentTypes addObject:@"text/plain"];
        self.responseSerializer.acceptableContentTypes = contentTypes;
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // setup reachability
        __weak OHMClient *weakSelf = self;
        [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf reachabilityStatusDidChange:status];
        }];
        [self.reachabilityManager startMonitoring];
        
        // enable network activity indicator
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        // configure background session for survey uploads
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"OHMBackgroundSessionConfiguration"];
        self.backgroundSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.baseURL sessionConfiguration:config];
        self.backgroundSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // if we have a logged-in user and network is reachable, authenticate and refresh
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


#pragma mark - User (Public)

/**
 *  saveClientState
 */
- (void)saveClientState
{
    [self saveManagedContext];
}

/**
 *  hasLoggedInUser
 */
- (BOOL)hasLoggedInUser
{
    return self.user != nil;
}

/**
 *  loggedInUser
 */
- (OHMUser *)loggedInUser
{
    return self.user;
}

/**
 *  loginWithEmail:password:completionBlock
 */
- (void)loginWithEmail:(NSString *)email password:(NSString *)password
       completionBlock:(void (^)(BOOL success, NSString *errorString))completionBlock
{
    // clear auth token
    [self setAuthorizationToken:nil];
    
    if (email == nil || password == nil) {
        if (completionBlock != nil) {
            completionBlock(NO, @"Email or password is blank");
        }
        return;
    }
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"email": email, @"password" : password};
    
    [self getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        NSString *errorString = nil;
        if (error) {
            errorString = response[kResponseErrorStringKey];
        }
        else {
            // login success, set logged-in user and auth tokens
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
            
            // clear new account flag after successful login
            self.user.isNewAccountValue = NO;
            
            // post-login setup
            [self didLogin];
            
        }
        
        if (completionBlock) {
            completionBlock( (error == nil), errorString);
        }
    }];
}

/**
 *  loginWithGoogleAuth:completionBlock
 */
- (void)loginWithGoogleAuth:(GTMOAuth2Authentication *)auth completionBlock:(void (^)(BOOL success))completionBlock
{
    // clear auth token
    [self setAuthorizationToken:nil];
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"provider": @"google", @"access_token" : auth.accessToken};
    
    [self getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            if (self.hasLoggedInUser) {
                // access token must be invalid, report failure to completion block
                if (completionBlock) {
                    completionBlock(NO);
                }
            }
            else {
                // no logged-in user, try creating one
                [self createAccountWithGoogleAuth:auth completionBlock:completionBlock];
            }
        }
        else {
            // login success, update logged-in user and auth tokens
            self.authToken = [response authToken];
            self.refreshToken = [response refreshToken];
            [self setAuthorizationToken:self.authToken];
            
            [self updateUserWithGoogleAuth:auth userID:response.userID];
            
            // post-login setup
            [self didLogin];
            
            if (completionBlock) {
                completionBlock(YES);
            }
        }
    }];
}

/**
 *  createAccountWithName:email:completionBlock
 */
- (void)createAccountWithName:(NSString *)name
                        email:(NSString *)email
                     password:(NSString *)password
              completionBlock:(void (^)(BOOL success, NSString *errorString))completionBlock
{
    // clear auth token
    [self setAuthorizationToken:nil];
    
    NSString *request =  [NSString stringWithFormat:@"people?password=%@", password];
    NSDictionary *json = @{@"email": email, @"full_name": name};
    
    [self postRequest:request withParameters:json completionBlock:^(NSDictionary *response, NSError *error) {
        NSString *errorString = nil;
        if (error) {
            errorString = response[kResponseErrorStringKey];
        }
        else {
            
            // account creation succeeded
            self.user = [self userWithOhmID:email]; //temp id
            self.user.email = email;
            self.user.password = password;
            self.user.fullName = name;
            
            // mark user as a new account with temp ID
            self.user.isNewAccountValue = YES;
            
        }
        
        if (completionBlock) {
            completionBlock( (error == nil), errorString);
        }
    }];
}

/**
 *  logout
 */
- (void)logout
{
    if (self.user.usesGoogleAuthValue) {
        [[GPPSignIn sharedInstance] signOut];
    }
    self.user = nil;
    self.lastRefresh = nil;
    [self.delegate OHMClientDidUpdate:self];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[OHMLocationManager sharedLocationManager] stopMonitoringAllRegions];
    [self saveClientState];
}

/**
 *  clearUserData
 */
- (void)clearUserData
{
    // clear all data for current user
    
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

/**
 *  submitSurveyResponse
 */
- (void)submitSurveyResponse:(OHMSurveyResponse *)surveyResponse
{
    // timestamp and mark as submitted by user
    surveyResponse.timestamp = [NSDate date];
    surveyResponse.userSubmittedValue = YES;
    surveyResponse.survey.isDueValue = NO;
    
    // add location data if available
    if ([OHMLocationManager sharedLocationManager].hasLocation) {
        CLLocation *location = [OHMLocationManager sharedLocationManager].location;
        surveyResponse.locLongitudeValue = location.coordinate.longitude;
        surveyResponse.locLatitudeValue = location.coordinate.latitude;
        surveyResponse.locAccuracyValue = location.horizontalAccuracy;
        surveyResponse.locTimestamp = location.timestamp;
    }
    
    [self saveClientState];
    
    // upload response if we have a network connection
    if (self.reachabilityManager.isReachable) {
        [self uploadSurveyResponse:surveyResponse];
    }
    
}

#pragma mark - User (Private)


/**
 *  setUser
 */
- (void)setUser:(OHMUser *)user
{
    _user = user;
    
    // keep track of current logged-in user by ID
    [self setPersistentStoreMetadataText:user.ohmID forKey:@"loggedInUserID"];
}

/**
 *  authenticateCurrentUser
 */
- (void)authenticateCurrentUser
{
    if (self.user.usesGoogleAuthValue) {
        [self refreshGoogleAuthentication];
    }
    else {
        [self loginWithEmail:self.user.email password:self.user.password completionBlock:nil];
    }
}

/**
 *  refreshGoogleAuthentication
 */
- (void)refreshGoogleAuthentication
{
    GPPSignIn *googleSignIn = [GPPSignIn sharedInstance];
    googleSignIn.delegate = self;
    googleSignIn.clientID = kGoogleClientId;
    googleSignIn.attemptSSO = YES;
    BOOL success = [googleSignIn trySilentAuthentication];
    if (!success) {
        [googleSignIn authenticate];
    }
}

/**
 *  refreshLoginWithCompletionBlock
 */
- (void)refreshLoginWithCompletionBlock:(void (^)(BOOL success, NSString *errorString))completionBlock
{
    if (self.refreshToken == nil) return;
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"refresh_token": self.refreshToken};
    
    [self getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        NSString *errorString = nil;
        if (error) {
            errorString = response[kResponseErrorStringKey];
        }
        else {
            self.authToken = [response authToken];
            self.refreshToken = [response refreshToken];
            [self setAuthorizationToken:self.authToken];
            [self refreshUserInfo];
            
        }
        
        if (completionBlock) {
            completionBlock( (error == nil), errorString);
        }
    }];
}

/**
 *  createAccountWithGoogleAuth:completionBlock
 */
- (void)createAccountWithGoogleAuth:(GTMOAuth2Authentication *)auth completionBlock:(void (^)(BOOL success))completionBlock
{
    // clear auth token
    [self setAuthorizationToken:nil];
    
    NSString *request =  [NSString stringWithFormat:@"people?provider=google&access_token=%@", auth.accessToken];
    GTLPlusPerson *user = [GPPSignIn sharedInstance].googlePlusUser;
    NSString *email = auth.parameters[@"email"];
    NSDictionary *json = @{@"email": email, @"full_name": user.displayName};
    
    [self postRequest:request withParameters:json completionBlock:^(NSDictionary *response, NSError *error) {
        
        if (error == nil) {
            // account creation succeeded, setup google user
            [self updateUserWithGoogleAuth:auth userID:response.userID];
        }
        
        if (completionBlock) {
            completionBlock(error == nil);
        }
    }];
    
}

/**
 *  updateUserWithGoogleAuth:userID
 */
- (void)updateUserWithGoogleAuth:(GTMOAuth2Authentication *)auth userID:(NSString *)userID
{
    GTLPlusPerson *user = [GPPSignIn sharedInstance].googlePlusUser;
    NSString *email = auth.parameters[@"email"];
    
    self.user = [self userWithOhmID:email]; // temp id
    self.user.email = email;
    self.user.fullName = user.displayName;
    self.user.usesGoogleAuthValue = YES;
    if (userID != nil) {
        // clear new account flag if we have actual user ID
        self.user.ohmID = userID;
        self.user.isNewAccountValue = NO;
    }
    else {
        // flag as new account with temp ID
        self.user.isNewAccountValue = YES;
    }
}

/**
 *  didLogin
 */
- (void)didLogin
{
    // refresh ohmlets
    [self refreshUserInfo];
    
    // start tracking location for reminders and survey response metadata
    if ([CLLocationManager locationServicesEnabled]) {
        OHMLocationManager *appLocationManager = [OHMLocationManager sharedLocationManager];
        [appLocationManager.locationManager startUpdatingLocation];
    }
    
    [[OHMReminderManager sharedReminderManager] synchronizeReminders];
    [self submitPendingSurveyResponses];
}


#pragma mark - HTTP

/**
 *  reachabilityStatusDidChange
 */
- (void)reachabilityStatusDidChange:(AFNetworkReachabilityStatus)status
{
    // when network becomes reachable, re-authenticate user
    // and upload any pending survey responses
    if (status > AFNetworkReachabilityStatusNotReachable && self.hasLoggedInUser) {
        [self authenticateCurrentUser];
    }
}

/**
 *  setAuthorizationToken
 */
- (void)setAuthorizationToken:(NSString *)token
{
    if (token) {
        [self.requestSerializer setValue:[self authorizationHeaderWithToken:token] forHTTPHeaderField:@"Authorization"];
    }
    else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    }
}

/**
 *  authorizationHeaderWithToken
 */
- (NSString *)authorizationHeaderWithToken:(NSString *)token
{
    if (token) {
        return [@"ohmage " stringByAppendingString:token];
    }
    else {
        return nil;
    }
}

/**
 *  getRequest:withParameters:completionBlock
 */
- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // request succeeded
        block((NSDictionary *)responseObject, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // request failed
        block([self responseDictionaryForError:error], error);
    }];
}

/**
 *  postRequest:withParameters:completionBlock
 */
- (void)postRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *, NSError *))block
{
    [self POST:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // request succeeded
        block((NSDictionary *)responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // request failed
        block([self responseDictionaryForError:error], error);
    }];
}

/**
 *  responseDictionaryForError
 */
- (NSDictionary *)responseDictionaryForError:(NSError *)error
{
    NSString *errorString = error.userInfo[JSONResponseSerializerWithDataKey];
    NSDictionary *errorResponse = @{kResponseErrorStringKey : errorString};
    return errorResponse;
}

/**
 *  buildResponseBodyForSurveyResponse:withFormData
 */
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
                // should handle error
            }
        }
    }
}

/**
 *  submitUploadRequest:forSurveyResponse:retry
 */
- (void)submitUploadRequest:(NSMutableURLRequest *)request
          forSurveyResponse:(OHMSurveyResponse *)surveyResponse
                      retry:(BOOL)retry
{
    NSURLSessionUploadTask *task =
    [self.backgroundSessionManager uploadTaskWithRequest:request
                                                fromFile:surveyResponse.tempFileURL
                                                progress:nil
                                       completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
     {
         if (error != nil) {
             // upload task failed
             
             // if status is a 401, re-authenticate and try again
             NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
             if (statusCode == 401 && retry) {
                 [self refreshLoginWithCompletionBlock:^(BOOL success, NSString *errorString) {
                     if (success) {
                         // need to set the auth token since token from original request failed.
                         [request setValue:[self authorizationHeaderWithToken:self.authToken] forHTTPHeaderField:@"Authorization"];
                         [self submitUploadRequest:request forSurveyResponse:surveyResponse retry:NO];
                     }
                 }];
             }
         }
         else if ([responseObject isKindOfClass:[NSArray class]]) {
             // updoad task succeeded
             
             NSArray *responseArray = (NSArray *)responseObject;
             NSDictionary *returnedSurveyResponseDef = [responseArray firstObject];
             NSString *ohmId = returnedSurveyResponseDef.surveyResponseMetadata.surveyResponseID;
             if ([surveyResponse.ohmID isEqualToString:ohmId]) {
                 // mark survey response as submitted
                 surveyResponse.submissionConfirmedValue = YES;
                 [self saveClientState];
             }
         }
     }];
    
    [task resume];
    
    [self saveClientState];
}

/**
 *  uploadSurveyResponse
 */
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
        return;
    }
    
    request.allowsCellularAccess = self.user.useCellularDataValue;
    request = [self.backgroundSessionManager.requestSerializer requestWithMultipartFormRequest:request
                                                                   writingStreamContentsToFile:surveyResponse.tempFileURL
                                                                             completionHandler:^(NSError *error)
       {
           if (error == nil) {
               [self submitUploadRequest:request forSurveyResponse:surveyResponse retry:YES];
           }
       }];
}

/**
 *  submitPendingSurveyResponses
 */
- (void)submitPendingSurveyResponses
{
    // only upload over cellular connection if user has allowed it in their settings
    if (!self.reachabilityManager.reachableViaWiFi && !self.user.useCellularDataValue)
        return;
    
    NSArray *pendingResponses = [self pendingSurveyResponses];
    for (OHMSurveyResponse *response in pendingResponses) {
        [self uploadSurveyResponse:response];
    }
}

/**
 *  shouldRefresh
 */
- (BOOL)shouldRefresh
{
    if (self.lastRefresh == nil) return YES;
    else {
        // don't refresh more than once per hour
        NSDate *hourAgo = [[NSDate date] dateByAddingHours:-1];
        return [self.lastRefresh isBeforeDate:hourAgo];
    }
}

/**
 *  refreshUserInfo
 */
- (void)refreshUserInfo
{
    if (![self shouldRefresh]) return;
    
    [self getRequest:[self.user definitionRequestUrlString]
      withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
          
          if (error == nil) {
              self.lastRefresh = [NSDate date];
              
              self.user.fullName = [response userFullName];
              
              // refresh ohmlets and surveys
              [self refreshOhmlets:[response ohmlets]];
              
              [self.delegate OHMClientDidUpdate:self];
              [self saveClientState];
          }
      }];
}

/**
 *  refreshOhmlets
 */
- (void)refreshOhmlets:(NSArray *)ohmletDefinitions
{
    NSMutableOrderedSet *ohmlets = [NSMutableOrderedSet orderedSetWithCapacity:[ohmletDefinitions count]];
    for (NSDictionary *ohmletDefinition in ohmletDefinitions) {
        
        // fetch ohmlet for ID from database, or create it if it doesn't exist
        OHMOhmlet *ohmlet = [self ohmletWithOhmID:[ohmletDefinition ohmletID]];
        
        // synchronize local ohmlet info with definition from server
        [self refreshOhmletInfo:ohmlet];
        [self refreshSurveys:[ohmletDefinition surveyDefinitions] forOhmlet:ohmlet];
        
        // add to user's ohmlets
        [ohmlets addObject:ohmlet];
    }
    self.user.ohmlets = ohmlets;
}

/**
 *  refreshOhmletInfo
 */
- (void)refreshOhmletInfo:(OHMOhmlet *)ohmlet
{
    // request a detailed definition of ohmlet from server
    // (ohmlet definitions in user definition aren't complete)
    [self getRequest:[ohmlet definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error == nil) {
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

/**
 *  refreshSurveys:forOhmlet
 */
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

/**
 *  loadSurveyFromServer
 */
- (void)loadSurveyFromServer:(OHMSurvey *)survey
{
    [self getRequest:[survey definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error == nil) {
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

/**
 *  createSurveyItems:forSurvey
 */
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

/**
 *  createChoicesForSurveyItem:withDefinition
 */
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
                break;
        }
    }
}


#pragma mark - Property Accessors (Core Data)

/**
 *  persistentStoreURL
 */
- (NSURL *)persistentStoreURL
{
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
- (NSManagedObjectContext *)managedObjectContext
{
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
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    return _managedObjectModel;
}

/**
 *  persistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.persistentStoreURL options:nil error:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            NSLog(@"Error opening persistant store, resetting client\n%@\n%@", error, [error userInfo]);
            [self resetClient];
        }
    }
    
    return _persistentStoreCoordinator;
}

/**
 *  persistentStoreMetadataTextForKey
 */
- (NSString *)persistentStoreMetadataTextForKey:(NSString *)key
{
    NSPersistentStore *store = [self.persistentStoreCoordinator persistentStoreForURL:self.persistentStoreURL];
    NSDictionary *metadata = [self.persistentStoreCoordinator metadataForPersistentStore:store];
    return metadata[key];
}

/**
 *  setPersistentStoreMetadataText:forKey
 */
- (void)setPersistentStoreMetadataText:(NSString *)text forKey:(NSString *)key
{
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


#pragma mark - Model (public)

/**
 *  ohmlets
 */
- (NSOrderedSet *)ohmlets
{
    return self.user.ohmlets;
}

/**
 *  reminders
 */
- (NSArray *)reminders
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"specificTime" ascending:NO];
    return [self.user.reminders sortedArrayUsingDescriptors:@[sortDescriptor]];
}

/**
 *  timeReminders
 */
- (NSArray *)timeReminders
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocationReminder != YES"];
    return [[self reminders] filteredArrayUsingPredicate:predicate];
}

/**
 *  reminderLocations
 */
- (NSArray *)reminderLocations
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    return [self.user.reminderLocations sortedArrayUsingDescriptors:@[sortDescriptor]];
}

/**
 *  surveysForOhmlet
 */
- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"surveyName" ascending:YES];
    return [ohmlet.surveys sortedArrayUsingDescriptors:@[sortDescriptor]];
}

/**
 *  reminderWithOhmID
 */
- (OHMReminder *)reminderWithOhmID:(NSString *)ohmId
{
    return (OHMReminder *)[self fetchObjectForEntityName:[OHMReminder entityName] withUniqueOhmID:ohmId create:NO];
}

/**
 *  insertNewReminderLocation
 */
- (OHMReminderLocation *)insertNewReminderLocation
{
    OHMReminderLocation *location = (OHMReminderLocation *)[self insertNewObjectForEntityForName:[OHMReminderLocation entityName]];
    location.user = self.user;
    return location;
}


/**
 *  locationWithOhmID
 */
- (OHMReminderLocation *)locationWithOhmID:(NSString *)ohmId
{
    return (OHMReminderLocation *)[self fetchObjectForEntityName:[OHMReminderLocation entityName] withUniqueOhmID:ohmId create:NO];
}

/**
 *  buildResponseForSurvey
 */
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

/**
 *  buildNewReminderForSurvey
 */
- (OHMReminder *)buildNewReminderForSurvey:(OHMSurvey *)survey
{
    OHMReminder *reminder = (OHMReminder *)[self insertNewObjectForEntityForName:[OHMReminder entityName]];
    reminder.survey = survey;
    reminder.user = self.user;
    reminder.weekdaysMaskValue = OHMRepeatDayEveryday;
    reminder.enabledValue = YES;
    return reminder;
}


#pragma mark - Model (private)

/**
 *  pendingSurveyResponses
 */
- (NSArray *)pendingSurveyResponses
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userSubmitted == YES AND submissionConfirmed == NO"];
    return [self fetchManagedObjectsWithEntityName:[OHMSurveyResponse entityName] predicate:predicate sortDescriptors:nil fetchLimit:0];
}

/**
 *  userWithOhmID
 */
- (OHMUser *)userWithOhmID:(NSString *)ohmID
{
    return (OHMUser *)[self fetchObjectForEntityName:[OHMUser entityName] withUniqueOhmID:ohmID create:YES];
}

/**
 *  ohmletWithOhmID
 */
- (OHMOhmlet *)ohmletWithOhmID:(NSString *)ohmID
{
    return (OHMOhmlet *)[self fetchObjectForEntityName:[OHMOhmlet entityName] withUniqueOhmID:ohmID create:YES];
}

/**
 *  surveyWithOhmID:andVersion
 */
- (OHMSurvey *)surveyWithOhmID:(NSString *)ohmID andVersion:(int16_t)version
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ohmID == %@) AND (surveyVersion == %d)", ohmID, version];
    OHMSurvey *survey = (OHMSurvey *)[self fetchObjectForEntityName:[OHMSurvey entityName] withUniquePredicate:predicate create:YES];
    survey.ohmID = ohmID;
    survey.surveyVersionValue = version;
    return survey;
}

/**
 *  insertNewSurveyItem
 */
- (OHMSurveyItem *)insertNewSurveyItem
{
    OHMSurveyItem *newItem = (OHMSurveyItem *)[self insertNewObjectForEntityForName:[OHMSurveyItem entityName]];
    return newItem;
}

/**
 *  insertNewSurveyResponse
 */
- (OHMSurveyResponse *)insertNewSurveyResponse
{
    return (OHMSurveyResponse *)[self insertNewObjectForEntityForName:[OHMSurveyResponse entityName]];
}

/**
 *  insertNewSurveyPromptResponse
 */
- (OHMSurveyPromptResponse *)insertNewSurveyPromptResponse
{
    return (OHMSurveyPromptResponse *)[self insertNewObjectForEntityForName:[OHMSurveyPromptResponse entityName]];
}

/**
 *  fetchObjectForEntityName:withUniqueOhmID:create
 */
- (OHMObject *)fetchObjectForEntityName:(NSString *)entityName withUniqueOhmID:(NSString *)ohmID create:(BOOL)create
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ohmID == %@", ohmID];
    OHMObject *object = (OHMObject *)[self fetchObjectForEntityName:entityName withUniquePredicate:predicate create:create];
    object.ohmID = ohmID;
    return object;
}

/**
 *  fetchObjectForEntityName:withUniquePredicate:create
 */
- (NSManagedObject *)fetchObjectForEntityName:(NSString *)entityName withUniquePredicate:(NSPredicate *)predicate create:(BOOL)create
{
    NSArray *results = [self allObjectsWithEntityName:entityName sortKey:nil predicate:predicate ascending:NO];
    
    if ([results count]) {
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
- (NSArray *)allObjectsWithEntityName:(NSString *)entityName sortKey:(NSString *)sortKey predicate:(NSPredicate *)predicate ascending:(BOOL)ascending
{
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
                                    fetchLimit:(NSUInteger)fetchLimit
{
    
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
 *  saveManagedContext
 */
- (void)saveManagedContext
{
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"Error saving context: %@", [error localizedDescription]);
    }
}

/**
 *  deletePersistentStore
 */
- (void)deletePersistentStore
{
    NSLog(@"Deleting persistent store.");
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:self.persistentStoreURL error:nil];
    
    self.persistentStoreURL = nil;
}

/**
 *  resetClient
 */
- (void)resetClient
{
    [self deletePersistentStore];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[OHMLocationManager sharedLocationManager] stopMonitoringAllRegions];
}


#pragma mark - Code Data (public)

/**
 *  deleteObject
 */
- (void)deleteObject:(NSManagedObject *)object
{
    [self.managedObjectContext deleteObject:object];
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



#pragma mark - Google Login Delegate

/**
 *  showGoogleLoginFailureAlert
 */
- (void)showGoogleLoginFailureAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Google Authentication Failed" message:@"You have been logged out because your google account failed to authenticate." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

/**
 *  finishedWithAuth:error
 */
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
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
