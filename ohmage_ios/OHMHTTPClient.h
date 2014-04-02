//
//  OHMHTTPClient.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol OHMHTTPClientDelegate;

@interface OHMHTTPClient : AFHTTPSessionManager

@property (nonatomic, weak) id<OHMHTTPClientDelegate>delegate;

+ (OHMHTTPClient*)sharedClient;

- (void)setAuthorizationToken:(NSString *)token;
- (void)getRequest:(NSString *)request withParameters:(NSDictionary *)parameters
   completionBlock:(void (^)(NSDictionary *response, NSError *error))block;

@end

@protocol OHMHTTPClientDelegate <NSObject>
@optional
- (void)OHMHTTPClient:(OHMHTTPClient*)client didFailWithError:(NSError *)error;
@end
