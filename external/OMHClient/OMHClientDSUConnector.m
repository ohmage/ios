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
#import "OMHApplication.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#ifdef OMHDEBUG
#   define OMHLog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define OMHLog(...)
#endif

NSString * const kDSUBaseURL = @"https://lifestreams.smalldata.io/dsu/";

NSString * const kAppGoogleClientIDKey = @"AppGoogleClientID";
NSString * const kServerGoogleClientIDKey = @"ServerGoogleClientID";
NSString * const kAppDSUClientIDKey = @"AppDSUClientID";
NSString * const kAppDSUClientSecretKey = @"AppDSUClientSecret";
NSString * const kSignedInUserEmailKey = @"SignedInUserEmail";
NSString * const kHomeServerCodeKey = @"HomeServerCode";

static OMHClient *_sharedClient = nil;
static GPPSignIn *_gppSignIn = nil;


@interface OMHClient () <GPPSignInDelegate, UIWebViewDelegate>

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, strong) NSString *dsuAccessToken;
@property (nonatomic, strong) NSString *dsuRefreshToken;
@property (nonatomic, strong) NSDate *accessTokenDate;
@property (nonatomic, assign) NSTimeInterval accessTokenValidDuration;

@property (nonatomic, strong) NSMutableArray *pendingDataPoints;

@property (nonatomic, assign) BOOL isAuthenticated;
@property (atomic, assign) BOOL isAuthenticating;
@property (nonatomic, strong) NSMutableArray *authRefreshCompletionBlocks;

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

@end

@implementation OMHClient

+ (void)setupClientWithAppGoogleClientID:(NSString *)appGooggleClientID
                    serverGoogleClientID:(NSString *)serverGoogleClientID
                          appDSUClientID:(NSString *)appDSUClientID
                      appDSUClientSecret:(NSString *)appDSUClientSecret
{
    [self setAppGoogleClientID:appGooggleClientID];
    [self setServerGoogleClientID:serverGoogleClientID];
    [self setAppDSUClientID:appDSUClientID];
    [self setAppDSUClientSecret:appDSUClientSecret];
}

+ (instancetype)sharedClient
{
    if (_sharedClient == nil) {
        OMHClient *client = nil;
        NSString *signedInUserEmail = [self signedInUserEmail];
        
        if (signedInUserEmail != nil) {
            NSData *encodedClient = [self encodedClientForEmail:signedInUserEmail];
            
            if (encodedClient != nil) {
                client = (OMHClient *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedClient];
            }
        }
        
        if (client == nil) {
            client = [[self alloc] initPrivate];
        }
        
        _sharedClient = client;
    }
    
    return _sharedClient;
}

+ (void)releaseShared
{
    _sharedClient = nil;
    _gppSignIn = nil;
}

+ (NSString *)archiveKeyForEmail:(NSString *)email
{
    return [NSString stringWithFormat:@"OMHClient_%@", email];
}

+ (NSData *)encodedClientForEmail:(NSString *)email
{
    OMHLog(@"unarchiving client for email: %@", email);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:[self archiveKeyForEmail:email]];
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OMHClient sharedClient]"
                                 userInfo:nil];
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)commonInit
{
    OMHLog(@"common init");
    [self.httpSessionManager.reachabilityManager startMonitoring];
    [OMHClient gppSignIn].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleOpenGoogleAuthNotification:)
                                                 name:ApplicationOpenGoogleAuthNotification
                                               object:nil];
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
    [encoder encodeObject:self.dsuAccessToken forKey:@"client.dsuAccessToken"];
    [encoder encodeObject:self.dsuRefreshToken forKey:@"client.dsuRefreshToken"];
    [encoder encodeObject:self.pendingDataPoints forKey:@"client.pendingDataPoints"];
    [encoder encodeObject:self.accessTokenDate forKey:@"client.accessTokenDate"];
    [encoder encodeDouble:self.accessTokenValidDuration forKey:@"client.accessTokenValidDuration"];
}

- (void)unarchivePendingDataPointsForEmail:(NSString *)email
{
    NSData *encodedClient = [OMHClient encodedClientForEmail:email];
    if (encodedClient != nil) {
        OMHClient *archivedClient = (OMHClient *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedClient];
        if (archivedClient != nil) {
            self.pendingDataPoints = archivedClient.pendingDataPoints;
        }
    }
}

- (void)saveClientState
{
    OMHLog(@"saving client state, pending: %d", (int)self.pendingDataPoints.count);
    NSString *signedInUserEmail = [OMHClient signedInUserEmail];
    if (signedInUserEmail == nil) {
        OMHLog(@"attempting to save client with no signed-in user");
        return;
    }
    
    NSData *encodedClient = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:encodedClient forKey:[OMHClient archiveKeyForEmail:signedInUserEmail]];
    [userDefaults synchronize];
}

- (NSString *)encodedClientIDAndSecret
{
    static NSString *sEncodedIDAndSecret = nil;
    
    if (sEncodedIDAndSecret == nil) {
        NSString *appDSUClientID = [OMHClient appDSUClientID];
        NSString *appDSUClientSecret = [OMHClient appDSUClientSecret];
        
        if (appDSUClientID != nil && appDSUClientSecret != nil) {
            NSString *string = [NSString stringWithFormat:@"%@:%@",
                                appDSUClientID,
                                appDSUClientSecret];
            
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            sEncodedIDAndSecret = [data base64EncodedStringWithOptions:0];
        }
    }
    
    return sEncodedIDAndSecret;
}


#pragma mark - Property Accessors

+ (NSString *)appGoogleClientID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAppGoogleClientIDKey];
}

+ (void)setAppGoogleClientID:(NSString *)appGoogleClientID
{
    [self gppSignIn].clientID = appGoogleClientID;
    [[NSUserDefaults standardUserDefaults] setObject:appGoogleClientID forKey:kAppGoogleClientIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)serverGoogleClientID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kServerGoogleClientIDKey];
}

+ (void)setServerGoogleClientID:(NSString *)serverGoogleClientID
{
    [self gppSignIn].homeServerClientID = serverGoogleClientID;
    [[NSUserDefaults standardUserDefaults] setObject:serverGoogleClientID forKey:kServerGoogleClientIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)appDSUClientID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAppDSUClientIDKey];
}

+ (void)setAppDSUClientID:(NSString *)appDSUClientID
{
    [[NSUserDefaults standardUserDefaults] setObject:appDSUClientID forKey:kAppDSUClientIDKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)appDSUClientSecret
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kAppDSUClientSecretKey];
}

+ (void)setAppDSUClientSecret:(NSString *)appDSUClientSecret
{
    [[NSUserDefaults standardUserDefaults] setObject:appDSUClientSecret forKey:kAppDSUClientSecretKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)signedInUserEmail
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kSignedInUserEmailKey];
}

+ (void)setSignedInUserEmail:(NSString *)signedInUserEmail
{
    [[NSUserDefaults standardUserDefaults] setObject:signedInUserEmail forKey:kSignedInUserEmailKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)homeServerAuthorizationCode
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kHomeServerCodeKey];
}

+ (void)setHomeServerAuthorizationCode:(NSString *)serverCode
{
    [[NSUserDefaults standardUserDefaults] setObject:serverCode forKey:kHomeServerCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSMutableArray *)pendingDataPoints
{
    if (_pendingDataPoints == nil) {
        _pendingDataPoints = [NSMutableArray array];
    }
    return _pendingDataPoints;
}

- (NSMutableArray *)authRefreshCompletionBlocks
{
    if (_authRefreshCompletionBlocks == nil) {
        _authRefreshCompletionBlocks = [NSMutableArray array];
    }
    return _authRefreshCompletionBlocks;
}

- (BOOL)isSignedIn
{
    return (self.dsuAccessToken != nil && self.dsuRefreshToken != nil);
}

- (BOOL)isReachable
{
    if (!self.isSignedIn) return NO;
    return self.httpSessionManager.reachabilityManager.isReachable;
}

- (int)pendingDataPointCount
{
    return (int)self.pendingDataPoints.count;
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

- (void)getRequest:(NSString *)request
    withParameters:(NSDictionary *)parameters
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

- (void)postRequest:(NSString *)request
     withParameters:(NSDictionary *)parameters
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

- (void)authenticatedGetRequest:(NSString *)request
                 withParameters:(NSDictionary *)parameters
                completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block
{
    __block NSString *blockRequest = [request copy];
    __block NSDictionary *blockParameters = [parameters copy];
    __block void (^blockCompletionBlock)(id responseObject, NSError *error, NSInteger statusCode) = [block copy];
    [self refreshAuthenticationWithCompletionBlock:^(NSError *error) {
        if (error == nil) {
            [self getRequest:blockRequest withParameters:blockParameters completionBlock:blockCompletionBlock];
        }
        else {
            blockCompletionBlock(nil, error, 0);
        }
    }];
}

- (void)authenticatedPostRequest:(NSString *)request withParameters:(NSDictionary *)parameters
                completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block
{
    __block NSString *blockRequest = [request copy];
    __block NSDictionary *blockParameters = [parameters copy];
    __block void (^blockCompletionBlock)(id responseObject, NSError *error, NSInteger statusCode) = [block copy];
    [self refreshAuthenticationWithCompletionBlock:^(NSError *error) {
        if (error == nil) {
            [self postRequest:blockRequest withParameters:blockParameters completionBlock:blockCompletionBlock];
        }
        else {
            blockCompletionBlock(nil, error, 0);
        }
    }];
}

- (void)reachabilityStatusDidChange:(AFNetworkReachabilityStatus)status
{
    if (!self.isSignedIn) return;
    OMHLog(@"reachability status changed: %d", (int)status);
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
    OMHLog(@"setting dsu sign in header with token: %@", token);
    if (token) {
        self.httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSString *auth = [NSString stringWithFormat:@"Basic %@", token];
        [self.httpSessionManager.requestSerializer setValue:auth forHTTPHeaderField:@"Authorization"];
    }
}

- (void)setDSUUploadHeader
{
    OMHLog(@"setting dsu upload header: %@", self.dsuAccessToken);
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

- (void)refreshAuthenticationWithCompletionBlock:(void (^)(NSError *error))block
{
    OMHLog(@"refresh authentication, isAuthenticating: %d, refreshToken: %d", self.isAuthenticating, (self.dsuRefreshToken != nil));
    
    if (block) {
        [self.authRefreshCompletionBlocks addObject:[block copy]];
    }
    
    if (self.isAuthenticating || self.dsuRefreshToken == nil) return;
    
    self.isAuthenticating = YES;
    [self setDSUSignInHeader];
    
    NSString *request = @"oauth/token";
    NSDictionary *parameters = @{@"refresh_token" : self.dsuRefreshToken,
                                 @"grant_type" : @"refresh_token"};
    
    [self postRequest:request withParameters:parameters completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            OMHLog(@"refresh authentication success");
            
            [self storeAuthenticationResponse:(NSDictionary *)responseObject];
            [self setDSUUploadHeader];
            self.isAuthenticated = YES;
            [self uploadPendingDataPoints];
        }
        else {
            OMHLog(@"refresh authentiation failed: %@", error);
            self.isAuthenticated = NO;
        }
        
        self.isAuthenticating = NO;
        
        for (void (^completionBlock)(NSError *) in self.authRefreshCompletionBlocks) {
            completionBlock(error);
        }
        [self.authRefreshCompletionBlocks removeAllObjects];
    }];
}

- (void)submitDataPoint:(NSDictionary *)dataPoint
{
    if (!self.isSignedIn) {
        OMHLog(@"attempting to submit data point while not signed in");
        return;
    }
    
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
    OMHLog(@"uploading pending data points: %d, isAuthenticating: %d", (int)self.pendingDataPoints.count, self.isAuthenticating);
    
    for (NSDictionary *dataPoint in self.pendingDataPoints) {
        [self uploadDataPoint:dataPoint];
    }
}

- (void)uploadDataPoint:(NSDictionary *)dataPoint
{
    NSString *request = @"dataPoints";
    
    __block NSDictionary *blockDataPoint = dataPoint;
    [self postRequest:request withParameters:dataPoint completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            OMHLog(@"upload data point succeeded: %@", blockDataPoint[@"header"][@"id"]);
            [self.pendingDataPoints removeObject:dataPoint];
            [self saveClientState];
            if (self.uploadDelegate) {
                [self.uploadDelegate OMHClient:self didUploadDataPoint:blockDataPoint];
            }
        }
        else {
            OMHLog(@"upload data point failed: %@, status code: %d", blockDataPoint[@"header"][@"id"], (int)statusCode);
            if (statusCode == 409) {
                OMHLog(@"removing conflicting data point, is pending: %d", [self.pendingDataPoints containsObject:blockDataPoint]);
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

+ (GPPSignIn *)gppSignIn
{
    if (_gppSignIn == nil) {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.shouldFetchGooglePlusUser = YES;
        signIn.shouldFetchGoogleUserEmail = YES;
        
        signIn.scopes = @[ @"profile" ];
        _gppSignIn = signIn;
    }
    return _gppSignIn;
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    OMHLog(@"Client received google error %@ and auth object %@",error, auth);
    if (error) {
        if (self.signInDelegate) {
            [self.signInDelegate OMHClient:self signInFinishedWithError:error];
        }
    }
    else {
        NSString *serverCode = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
        if (serverCode == nil) serverCode = [OMHClient homeServerAuthorizationCode];
        
        if (serverCode != nil) {
            OMHLog(@"signed in user email: %@", auth.userEmail);
            [OMHClient setSignedInUserEmail:auth.userEmail];
            [OMHClient setHomeServerAuthorizationCode:serverCode];
            [self unarchivePendingDataPointsForEmail:auth.userEmail];
            [self signInToDSUWithServerCode:serverCode];
        }
        else {
            OMHLog(@"failed to receive server code from google auth");
            [self signOut];
            if (self.signInDelegate) {
                NSError *serverCodeError = [NSError errorWithDomain:@"OMHClientServerCodeError" code:0 userInfo:nil];
                [self.signInDelegate OMHClient:self signInFinishedWithError:serverCodeError];
            }
            
        }
    }
}

- (void)signInToDSUWithServerCode:(NSString *)serverCode
{
    NSString *appDSUClientID = [OMHClient appDSUClientID];
    if (serverCode == nil || appDSUClientID == nil) return;
    [self setDSUSignInHeader];
    
    NSString *request =  @"google-signin";
    NSString *code = [NSString stringWithFormat:@"fromApp_%@", serverCode];
    NSDictionary *parameters = @{@"code": code, @"client_id" : appDSUClientID};
    
    self.isAuthenticating = YES;
    [self getRequest:request withParameters:parameters completionBlock:^(id responseObject, NSError *error, NSInteger statusCode) {
        if (error == nil) {
            OMHLog(@"DSU login success, response object: %@", responseObject);
            [self storeAuthenticationResponse:(NSDictionary *)responseObject];
            [self setDSUUploadHeader];
            self.isAuthenticated = YES;
            self.isAuthenticating = NO;
            [self uploadPendingDataPoints];
            
            if (self.signInDelegate != nil) {
                [self.signInDelegate OMHClient:self signInFinishedWithError:nil];
            }
        }
        else {
            OMHLog(@"DSU login failure, error: %@", error);
            self.isAuthenticating = NO;
            [self signOut];
            
            if (self.signInDelegate != nil) {
                [self.signInDelegate OMHClient:self signInFinishedWithError:error];
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
    OMHLog(@"sign out");
    [[OMHClient gppSignIn] signOut];
    self.dsuAccessToken = nil;
    self.dsuRefreshToken = nil;
    self.accessTokenDate = nil;
    self.accessTokenValidDuration = 0;
    [self saveClientState];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSignedInUserEmailKey];
    
    [OMHClient releaseShared];
}

#pragma mark - Google Sign In Web View

- (void)handleOpenGoogleAuthNotification:(NSNotification *)notification
{
    NSURL *url = (NSURL *)notification.object;
    OMHLog(@"handle google auth notification with URL: %@", url);
    if (url == nil || self.signInDelegate == nil) return;
    
    UIWebView *webview = [[UIWebView alloc] init];
    webview.delegate = self;
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [webview addSubview:activityIndicator];
    [activityIndicator centerInView:webview];
    [activityIndicator startAnimating];
    self.activityIndicator = activityIndicator;
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = webview;
    vc.title = @"Sign In";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.signInDelegate presentViewController:nav animated:YES completion:nil];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *bundleID = [[NSBundle mainBundle].bundleIdentifier lowercaseString];
    OMHLog(@"webview should load url: %@\nBundle ID: %@", url, bundleID);
    NSString *appPrefix = [bundleID stringByAppendingString:@":/oauth2callback"];
    if ([[url absoluteString] hasPrefix:appPrefix]) {
        [GPPURLHandler handleURL:url sourceApplication:@"com.google.chrome.ios" annotation:nil];
        
        // Looks like we did log in (onhand of the url), we are logged in, the Google APi handles the rest
        if (self.signInDelegate != nil) {
            [self.signInDelegate dismissViewControllerAnimated:YES completion:nil];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator removeFromSuperview];
    self.activityIndicator = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (self.signInDelegate != nil) {
        [self.signInDelegate dismissViewControllerAnimated:YES completion:^{
            [self.signInDelegate OMHClient:self signInFinishedWithError:error];
        }];
    }
}

@end

