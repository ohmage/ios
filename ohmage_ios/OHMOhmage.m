//
//  OHMAccountManager.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/3/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMOhmage.h"
#import "OHMUser.h"

@interface OHMOhmage ()

@property (nonatomic, strong) OHMHTTPClient *httpClient;

@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *refreshToken;

@property (nonatomic, strong) OHMUser *user;
@property (nonatomic, copy) NSString *ohmletId;

@property (nonatomic, strong) NSMutableArray *surveys;

@end

@implementation OHMOhmage

+ (NSString *)accountArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"account.archive"];
}

+ (OHMOhmage*)sharedOhmage
{
    static OHMOhmage *_sharedOhmage = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // first check for archive
        NSString *path = [self accountArchivePath];
        _sharedOhmage = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_sharedOhmage) {
            _sharedOhmage = [[self alloc] initPrivate];
        }
    });
    
    return _sharedOhmage;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMAccountManager sharedOhmage]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        self.httpClient = [OHMHTTPClient sharedClient];
        self.user = [[OHMUser alloc] initWithEmail:@"cforkish@gmail.com" password:@"loudfowl98"];
        self.surveys = [NSMutableArray array];
    }
    
    return self;
}



- (void)login
{
    [self.httpClient setAuthorizationToken:nil];
    
    NSString *request =  @"auth_token";
    NSDictionary *parameters = @{@"email": self.user.email, @"password" : self.user.password};
    __weak OHMOhmage *weakSelf = self;
    
    [self.httpClient getRequest:request withParameters:parameters completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Login Error");
        }
        else {
            NSLog(@"Login Success");
            
            weakSelf.authToken = [response authToken];
            weakSelf.refreshToken = [response refreshToken];
            weakSelf.user.ohmId = [response userId];
            
            [weakSelf.httpClient setAuthorizationToken:weakSelf.authToken];
            
            [weakSelf refreshUserInfo];
        }
    }];
}

- (void)refreshUserInfo
{
    __weak OHMOhmage *weakSelf = self;
    
    [self.httpClient getRequest:[self.user definitionRequestUrlString]
                 withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
                     
         if (error) {
             NSLog(@"Refresh user info Error");
         }
         else {
             NSLog(@"Refresh user info Success");
             
             weakSelf.user.fullName = [response userFullName];
             
             NSDictionary *ohmletDef = [[response ohmlets] firstObject];
             weakSelf.ohmletId = [ohmletDef ohmletId];
             
             [weakSelf refreshSurveys:[ohmletDef surveyDefinitions]];
         }
     }];
}

- (NSArray *)ohmlets
{
    return nil;
}

- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet
{
    return [self.surveys copy];
}

- (NSInteger)surveyCount
{
    return [self.surveys count];
}

- (void)refreshSurveys:(NSArray *)surveyDefinitions
{
    NSMutableArray *toCreate = [surveyDefinitions mutableCopy];
    NSMutableArray *toUpdate = [NSMutableArray array];
    NSMutableArray *toRemove = [NSMutableArray array];
    
    for (OHMSurvey *survey in self.surveys) {
        
        NSUInteger existingIndex = [surveyDefinitions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [survey.ohmId isEqualToString:[(NSDictionary *)obj surveyId]];
        }];
        
        if (existingIndex != NSNotFound) {
            NSDictionary *existingDescription = [surveyDefinitions objectAtIndex:existingIndex];
            if (survey.surveyVersion < [existingDescription surveyVersion]) {
                [toUpdate addObject:survey];
            }
            else {
                [toCreate removeObject:existingDescription];
            }
        }
        else {
            [toRemove addObject:survey];
        }
    }
    
    [self.surveys removeObjectsInArray:toRemove];
    [self createSurveys:toCreate];
    [self updateSurveys:toUpdate];
    
    if ([self.delegate respondsToSelector:@selector(OHMOhmage:didRefreshSurveys:)]) {
        [self.delegate OHMOhmage:self didRefreshSurveys:[self.surveys copy]];
    }
}

- (void)createSurveys:(NSArray *)surveyDefinitions
{
    for (NSDictionary *surveyDefinition in surveyDefinitions) {
        [self.surveys addObject:[OHMSurvey loadFromServerWithDefinition:surveyDefinition]];
    }
}

- (void)updateSurveys:(NSArray *)staleSurveys
{
    for (OHMSurvey *survey in staleSurveys) {
        [survey updateFromServer];
    }
}

@end
