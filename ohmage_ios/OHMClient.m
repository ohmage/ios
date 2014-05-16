//
//  OHMClient.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMClient.h"
#import "AFNetworkActivityLogger.h"
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

static NSString * const OhmageServerUrl = @"https://dev.ohmage.org/ohmage";

@interface OHMClient ()

// Core Data
@property(nonatomic, copy) NSURL *persistentStoreURL;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// HTTP
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *refreshToken;

// Model
@property (nonatomic, strong) OHMUser *user;

@end

@implementation OHMClient

+ (OHMClient*)sharedClient
{
    static OHMClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:OhmageServerUrl]];
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
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        
        NSString *userID = [self persistentStoreMetadataTextForKey:@"loggedInUserID"];
        if (userID != nil) {
            self.user = [self userWithOhmID:userID];
            [self loginWithEmail:self.user.email password:self.user.password completionBlock:nil];
        }
    }
    
    return self;
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
            
            self.user = [self userWithOhmID:([response userID])];
            self.user.email = email;
            self.user.password = password;
            
            [self refreshUserInfo];
            
        }
        
        if (completionBlock) {
            completionBlock(error == nil);
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
            
            NSString *userID = email; //temp in case no ohmID returned
            if (response.userID) {
                userID = response.userID;
            }
            else if (response[@"id"] != [NSNull null] && response[@"id"] != nil) {
                userID = response[@"id"];
            }
            NSLog(@"setting user id for new account: %@", userID);
            
            self.user = [self userWithOhmID:userID];
            self.user.email = email;
            self.user.password = password;
            self.user.fullName = name;
            
        }
        if (completionBlock) {
            completionBlock(error == nil);
        }
    }];
}

- (void)logout
{
    self.user = nil;
    [self.delegate OHMClientDidUpdate:self];
    [self saveClientState];
}


#pragma mark - HTTP

- (void)setAuthorizationToken:(NSString *)token
{
    NSLog(@"set auth token: %@", token);
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
        NSLog(@"POST %@ Succeeded", request);
        block((NSDictionary *)responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"POST %@ Failed, task: %@, response: %@", request, task, task.response);
        block(nil, error);
    }];
}

- (void)submitSurveyResponse:(OHMSurveyResponse *)surveyResponse
{
    surveyResponse.timestamp = [NSDate date];
    surveyResponse.userSubmittedValue = YES;
    surveyResponse.survey.isDueValue = NO;
    NSLog(@"submit response: %@", [surveyResponse JSON]);
    
    [self postRequest:surveyResponse.uploadResquestUrlString
       withParameters:(NSDictionary *)[surveyResponse JSON].jsonArray
      completionBlock:^(NSDictionary *response, NSError *error) {
          NSLog(@"completion block for survey submission with response: %@, error: %@", response, error);
          // response should actually be an array
          if (![response isKindOfClass:[NSArray class]]) {
              NSLog(@"Submitted survey response is not an array");
              return;
          }
          NSArray *responseArray = (NSArray *)response;
          NSDictionary *returnedSurveyResponseDef = [responseArray firstObject];
          NSString *ohmId = returnedSurveyResponseDef.surveyResponseMetadata.surveyResponseID;
          if ([surveyResponse.ohmID isEqualToString:ohmId]) {
              NSLog(@"Submission confirmed for survey: %@", surveyResponse.survey.surveyName);
              surveyResponse.submissionConfirmedValue = YES;
          }
    }];
    
    [self saveClientState];
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
    for (NSDictionary *surveyDefinition in surveyDefinitions) {
        OHMSurvey * survey = [self surveyWithOhmID:[surveyDefinition surveyID] andVersion:[surveyDefinition surveyVersion]];
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
    NSLog(@"set store metadata text: %@ for key: %@", text, key);
    NSPersistentStore *store = [self.persistentStoreCoordinator persistentStoreForURL:self.persistentStoreURL];
    NSMutableDictionary *metadata = [[self.persistentStoreCoordinator metadataForPersistentStore:store] mutableCopy];
    if (text) {
        metadata[key] = text;
    }
    else {
        [metadata removeObjectForKey:key];
    }
    [self.persistentStoreCoordinator setMetadata:metadata forPersistentStore:store];
    NSLog(@"store metadata: %@ for key: %@", [self persistentStoreMetadataTextForKey:key], key);
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLocationReminder == NO"];
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
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:descriptors];
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
}

@end
