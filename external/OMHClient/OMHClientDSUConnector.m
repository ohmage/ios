//
//  OMHClientLibrary.m
//  OMHClient
//
//  Created by Charles Forkish on 12/11/14.
//  Copyright (c) 2014 Open mHealth. All rights reserved.
//

#import "OMHClientDSUConnector.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "OMHDataPoint.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

NSString * const kDSUBaseURL = @"https://lifestreams.smalldata.io/dsu/";


@interface OMHClient () <GPPSignInDelegate>

@property (nonatomic, strong) GPPSignIn *gppSignIn;
@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, strong) NSString *dsuAccessToken;
@property (nonatomic, strong) NSString *dsuRefreshToken;
@property (nonatomic, strong) NSDate *accessTokenDate;
@property (nonatomic, assign) NSTimeInterval accessTokenValidDuration;

@property (nonatomic, strong) NSMutableArray *pendingDataPoints;

@property (nonatomic, assign) BOOL isAuthenticated;
@property (atomic, assign) BOOL isAuthenticating;

@end

@implementation OMHClient

+ (instancetype)sharedClient
{
    static OMHClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *encodedClient = [defaults objectForKey:@"OMHClient"];
        if (encodedClient != nil) {
            _sharedClient = (OMHClient *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedClient];
        } else {
            _sharedClient = [[self alloc] initPrivate];
        }
    });
    
    return _sharedClient;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OMHClient sharedClient]"
                                 userInfo:nil];
    return nil;
}

- (void)commonInit
{
//    if (self.dsuRefreshToken != nil) {
//        [self refreshAuthentication];
//    }
    
    [self.httpSessionManager.reachabilityManager startMonitoring];
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        self.pendingDataPoints = [NSMutableArray array];
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self != nil) {
        _appDSUClientID = [decoder decodeObjectForKey:@"client.appDSUClientID"];
        _appDSUClientSecret = [decoder decodeObjectForKey:@"client.appDSUClientSecret"];
        _dsuAccessToken = [decoder decodeObjectForKey:@"client.dsuAccessToken"];
        _dsuRefreshToken = [decoder decodeObjectForKey:@"client.dsuRefreshToken"];
        _pendingDataPoints = [decoder decodeObjectForKey:@"client.pendingDataPoints"];
        _accessTokenDate = [decoder decodeObjectForKey:@"client.accessTokenDate"];
        _accessTokenValidDuration = [decoder decodeDoubleForKey:@"client.accessTokenValidDuration"];
        [self commonInit];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.appDSUClientID forKey:@"client.appDSUClientID"];
    [encoder encodeObject:self.appDSUClientSecret forKey:@"client.appDSUClientSecret"];
    [encoder encodeObject:self.dsuAccessToken forKey:@"client.dsuAccessToken"];
    [encoder encodeObject:self.dsuRefreshToken forKey:@"client.dsuRefreshToken"];
    [encoder encodeObject:self.pendingDataPoints forKey:@"client.pendingDataPoints"];
    [encoder encodeObject:self.accessTokenDate forKey:@"client.accessTokenDate"];
    [encoder encodeDouble:self.accessTokenValidDuration forKey:@"client.accessTokenValidDuration"];
}



- (void)saveClientState
{
    NSLog(@"saving client state, pending: %d", (int)self.pendingDataPoints.count);
    NSData *encodedClient = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedClient forKey:@"OMHClient"];
    [userDefaults synchronize];
}

- (NSString *)encodedClientIDAndSecret
{
    if (self.appDSUClientID == nil || self.appDSUClientSecret == nil) return nil;
    
    NSString *string = [NSString stringWithFormat:@"%@:%@",
                        self.appDSUClientID,
                        self.appDSUClientSecret];
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"encoded cliend id and secret: %@", [data base64EncodedStringWithOptions:0]);
    return [data base64EncodedStringWithOptions:0];
    
}


#pragma mark - Property Accessors

- (void)setAppGoogleClientID:(NSString *)appGoogleClientID
{
    _appGoogleClientID = appGoogleClientID;
    self.gppSignIn.clientID = appGoogleClientID;
}

- (void)setServerGoogleClientID:(NSString *)serverGoogleClientID
{
    _serverGoogleClientID = serverGoogleClientID;
    self.gppSignIn.homeServerClientID = serverGoogleClientID;
}

- (BOOL)isSignedIn
{
    return (self.dsuAccessToken != nil && self.dsuRefreshToken != nil);
}


#pragma mark - HTTP Session Manager

- (AFHTTPSessionManager *)httpSessionManager
{
    if (_httpSessionManager == nil) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kDSUBaseURL]];
        
        // setup reachability
        __weak OMHClient *weakSelf = self;
        [_httpSessionManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [weakSelf reachabilityStatusDidChange:status];
        }];
        
        // enable network activity indicator
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return _httpSessionManager;
}

- (NSInteger)statusCodeFromSessionTask:(NSURLSessionTask *)task
{
    NSURLResponse *response = task.response;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        return ((NSHTTPURLResponse *)response).statusCode;
    }
    else {
        return 0;
    }
}

- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block
{
    [self.httpSessionManager GET:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // request succeeded
        block(responseObject, nil, [self statusCodeFromSessionTask:task]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // request failed
        block(nil, error, [self statusCodeFromSessionTask:task]);
    }];
}

- (void)postRequest:(NSString *)request withParameters:(NSDictionary *)parameters
    completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block
{
    [self.httpSessionManager POST:request parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // request succeeded
        block(responseObject, nil, [self statusCodeFromSessionTask:task]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // request failed
        block(nil, error, [self statusCodeFromSessionTask:task]);
    }];
}

- (void)reachabilityStatusDidChange:(AFNetworkReachabilityStatus)status
{
    if (!self.isSignedIn) return;
    NSLog(@"reachability status changed: %d", (int)status);
    // when network becomes reachable, re-authenticate user
    // and upload any pending survey responses
    if (status > AFNetworkReachabilityStatusNotReachable) {
        if ([self accessTokenHasExpired] || !self.isAuthenticated) {
            [self refreshAuthenticationWithCompletionBlock:nil];
        }
        else {
            [self uploadPendingDataPoints];
        }
    }
}

- (void)setDSUSignInHeader
{
    NSString *token = [self encodedClientIDAndSecret];
    NSLog(@"setting dsu sign in header with token: %@", token);
    if (token) {
        self.httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSString *auth = [NSString stringWithFormat:@"Basic %@", token];
        [self.httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    }
}

- (void)setDSUUploadHeader
{
    NSLog(@"setting dsu upload header: %@", self.dsuAccessToken);
    if (self.dsuAccessToken) {
        self.httpSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *auth = [NSString stringWithFormat:@"Bearer %@", self.dsuAccessToken];
        [self.httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    }
}

- (void)storeAuthenticationResponse:(NSDictionary *)responseDictionary
{
    self.dsuAccessToken = responseDictionary[@"access_token"];
    self.dsuRefreshToken = responseDictionary[@"refresh_token"];
    self.accessTokenDate = [NSDate date];
    self.accessTokenValidDuration = [responseDictionary[@"expires_in"] doubleValue];
    [self saveClientState];
}

- (BOOL)accessTokenHasExpired
{
    NSDate *validDate = [self.accessTokenDate dateByAddingTimeInterval:self.accessTokenValidDuration];
    NSComparisonResult comp = [validDate compare:[NSDate date]];
    return (comp == NSOrderedAscending);
}

- (void)refreshAuthenticationWithCompletionBlock:(void (^)(BOOL success))block
{
    NSLog(@"refresh authentication, isAuthenticating: %d, refreshToken: %d", self.isAuthenticating, (self.dsuRefreshToken != nil));
    if (self.isAuthenticating || self.dsuRefreshToken == nil) return;
    
    self.isAuthenticating = YES;
    [self setDSUSignInHeader];
    
    NSString *request = @"oauth/token";
    NSDictionary *parameters = @{@"refresh_token" : self.dsuRefreshToken,
                                 @"grant_type" : @"refresh_token"};
    
    [self postRequest:request withParameters:parameters completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            NSLog(@"refresh authentication success: %@", responseObject);
            
            [self storeAuthenticationResponse:(NSDictionary *)responseObject];
            [self setDSUUploadHeader];
            self.isAuthenticated = YES;
        }
        else {
            NSLog(@"refresh authentiation failed: %@", error);
            self.isAuthenticated = NO;
        }
        
        self.isAuthenticating = NO;
        
        if (block != nil) {
            block(error == nil);
        }
    }];
}

- (void)submitDataPoint:(NSDictionary *)dataPoint
{
    [self.pendingDataPoints addObject:dataPoint];
    [self saveClientState];
    
    if (self.isAuthenticating) return;
    
    if ([self accessTokenHasExpired] || !self.isAuthenticated) {
        [self refreshAuthenticationWithCompletionBlock:nil];
    }
    else {
        [self uploadDataPoint:dataPoint];
    }
}

- (void)uploadPendingDataPoints
{
//    NSLog(@"uploading pending data points: %d, isAuthenticating: %d", (int)self.pendingDataPoints.count, self.isAuthenticating);
    
    for (NSDictionary *dataPoint in self.pendingDataPoints) {
        [self uploadDataPoint:dataPoint];
    }
}

- (void)uploadDataPoint:(NSDictionary *)dataPoint
{
//    NSLog(@"uploading data point: %@, isAuthenticating: %d", dataPoint[@"header"][@"id"], self.isAuthenticating);
    
    NSString *request = @"dataPoints";
    
    __block NSDictionary *blockDataPoint = dataPoint;
    [self postRequest:request withParameters:dataPoint completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            NSLog(@"upload data point succeeded: %@", blockDataPoint[@"header"][@"id"]);
            [self.pendingDataPoints removeObject:dataPoint];
            [self saveClientState];
        }
        else {
            NSLog(@"upload data point failed: %@, status code: %d", blockDataPoint[@"header"][@"id"], (int)statusCode);
            if (statusCode == 409) {
                NSLog(@"removing conflicting data point, is pending: %d", [self.pendingDataPoints containsObject:blockDataPoint]);
                // conflict, data point already uploaded
                [self.pendingDataPoints removeObject:blockDataPoint];
                [self saveClientState];
            }
        }
    }];
}



#pragma mark - Google Login

+ (UIButton *)googleSignInButton
{
    GPPSignInButton *googleButton = [[GPPSignInButton alloc] init];
    googleButton.style = kGPPSignInButtonStyleWide;
    return googleButton;
}

- (GPPSignIn *)gppSignIn
{
    if (_gppSignIn == nil) {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;
        //        signIn.attemptSSO = YES;
        
        signIn.scopes = @[ @"profile" ];
        _gppSignIn = signIn;
        _gppSignIn.delegate = self;
    }
    return _gppSignIn;
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Client received google error %@ and auth object %@",error, auth);
    if (error) {
        if (self.signInDelegate) {
            [self.signInDelegate OMHClientSignInFinishedWithError:error];
        }
    }
    else {
        NSString *serverCode = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
        NSLog(@"serverCode: %@", serverCode);
        if (serverCode != nil) {
            [self signInToDSUWithServerCode:serverCode];
        }
        else {
            NSLog(@"failed to receive server code from google auth");
        }
    }
}

- (void)signInToDSUWithServerCode:(NSString *)serverCode
{
    [self setDSUSignInHeader];
    
    NSString *request =  @"google-signin";
    NSString *code = [NSString stringWithFormat:@"fromApp_%@", serverCode];
    NSDictionary *parameters = @{@"code": code, @"client_id" : self.appDSUClientID};
    
    self.isAuthenticating = YES;
    [self getRequest:request withParameters:parameters completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            NSLog(@"DSU login success, response object: %@", responseObject);
            [self storeAuthenticationResponse:(NSDictionary *)responseObject];
            [self setDSUUploadHeader];
            self.isAuthenticated = YES;
            self.isAuthenticating = NO;
            
            if (self.signInDelegate != nil) {
                [self.signInDelegate OMHClientSignInFinishedWithError:nil];
            }
        }
        else {
            NSLog(@"DSU login failure, error: %@", error);
            self.isAuthenticating = NO;
            
            if (self.signInDelegate != nil) {
                [self.signInDelegate OMHClientSignInFinishedWithError:error];
            }
        }
    }];
}

- (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)signOut
{
    NSLog(@"sign out");
    [self.gppSignIn signOut];
    
    self.dsuAccessToken = nil;
    self.dsuRefreshToken = nil;
    self.accessTokenDate = nil;
    self.accessTokenValidDuration = 0;
    [self saveClientState];
}

@end

