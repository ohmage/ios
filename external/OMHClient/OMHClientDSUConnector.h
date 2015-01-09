//
//  OMHClientLibrary.h
//  OMHClient
//
//  Created by Charles Forkish on 12/11/14.
//  Copyright (c) 2014 Open mHealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMHSignInDelegate;

@interface OMHClient : NSObject

+ (instancetype)sharedClient;

+ (UIButton *)googleSignInButton;

// global properties
+ (NSString *)appGoogleClientID;
+ (void)setAppGoogleClientID:(NSString *)appGoogleClientID;
+ (NSString *)serverGoogleClientID;
+ (void)setServerGoogleClientID:(NSString *)serverGoogleClientID;
+ (NSString *)appDSUClientID;
+ (void)setAppDSUClientID:(NSString *)appDSUClientID;
+ (NSString *)appDSUClientSecret;
+ (void)setAppDSUClientSecret:(NSString *)appDSUClientSecret;
+ (NSString *)signedInUserEmail;
+ (void)setSignedInUserEmail:(NSString *)signedInUserEmail;

@property (nonatomic, weak) id<OMHSignInDelegate> signInDelegate;
@property (nonatomic, readonly) BOOL isSignedIn;
@property (nonatomic, readonly) BOOL isReachable;


- (BOOL)handleURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication
       annotation:(id)annotation;

- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block;

- (void)postRequest:(NSString *)request withParameters:(NSDictionary *)parameters
    completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block;

//- (void)authenticatedGetRequest:(NSString *)request withParameters:(NSDictionary *)parameters
//                completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block;
//
//- (void)authenticatedPostRequest:(NSString *)request withParameters:(NSDictionary *)parameters
//                 completionBlock:(void (^)(id responseObject, NSError *error, NSInteger statusCode))block;

- (void)refreshAuthenticationWithCompletionBlock:(void (^)(BOOL success))block;
- (void)signOut;

- (void)submitDataPoint:(NSDictionary *)dataPoint;

@end


@protocol OMHSignInDelegate
- (void)OMHClient:(OMHClient *)client signInFinishedWithError:(NSError *)error;
@end
