//
//  NSDictionary+Ohmage.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "NSDictionary+Ohmage.h"

@implementation NSDictionary (Ohmage)

-(NSString *)authToken
{
    return self[@"access_token"];
}

- (NSString *)refreshToken
{
    return self[@"refresh_token"];
}

- (NSString *)userId
{
    return self[@"user_id"];
}

- (NSString *)userFullName
{
    return self[@"full_name"];
}

- (NSArray *)ohmlets
{
    return self[@"ohmlets"];
}

- (NSString *)ohmletId
{
    return self[@"ohmlet_id"];
}

- (NSString *)ohmletName
{
    return self[@"name"];
}

- (NSString *)ohmletDescription
{
    return self[@"description"];
}

- (NSArray *)surveyDefinitions
{
    return self[@"surveys"];
}

- (NSString *)surveyId
{
    return self[@"schema_id"];
}

- (NSInteger)surveyVersion
{
    NSNumber *versionNumber = self[@"schema_version"];
    if (versionNumber != (id)[NSNull null]) {
        return [versionNumber integerValue];
    }
    else {
        return 1;
    }
}

- (NSString *)surveyName
{
    return self[@"name"];
}

- (NSString *)surveyDescription
{
    return self[@"description"];
}

@end
