//
//  NSDictionary+Ohmage.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ohmage)

- (NSString *)authToken;
- (NSString *)refreshToken;
- (NSString *)userId;
- (NSString *)userFullName;

- (NSArray *)ohmlets;
- (NSString *)ohmletId;
- (NSString *)ohmletName;
- (NSString *)ohmletDescription;

- (NSArray *)surveyDefinitions;
- (NSString *)surveyId;
- (NSInteger)surveyVersion;


@end
