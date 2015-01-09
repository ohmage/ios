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

@property (nonatomic, weak) id<OMHSignInDelegate> signInDelegate;

@property (nonatomic, strong) NSString *appGoogleClientID;
@property (nonatomic, strong) NSString *serverGoogleClientID;
@property (nonatomic, strong) NSString *appDSUClientID;
@property (nonatomic, strong) NSString *appDSUClientSecret;

@property (nonatomic, readonly) NSString *signedInUserEmail;
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
