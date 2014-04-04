//
//  OHMHTTPClient.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/31/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMHTTPClient.h"
#import "AFNetworkActivityLogger.h"

static NSString * const OhmageServerUrl = @"https://dev.ohmage.org/ohmage";

@implementation OHMHTTPClient

+ (OHMHTTPClient*)sharedClient
{
    static OHMHTTPClient *_sharedClient = nil;
    
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
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        [[AFNetworkActivityLogger sharedLogger] startLogging];
    }
    
    return self;
}

- (void)setAuthorizationToken:(NSString *)token
{
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
        NSLog(@"GET %@ Succeeded", request);
        block((NSDictionary *)responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"GET %@ Failed", request);
        block(nil, error);
    }];
}

@end
