//
//  OHMClient.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class OHMOhmlet;

@interface OHMClient : AFHTTPSessionManager

+ (OHMClient*)sharedClient;

// HTTP
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)setAuthorizationToken:(NSString *)token;
- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *response, NSError *error))block;

// Model
//- (NSArray *)ohmlets;
- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet;
//- (NSInteger)surveyCount;

@end