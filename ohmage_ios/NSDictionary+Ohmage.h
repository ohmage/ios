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
- (NSString *)surveyName;
- (NSString *)surveyDescription;
- (NSArray *)surveyItems;

- (NSString *)surveyItemTypeKey;
- (NSString *)surveyItemId;
- (NSString *)surveyItemCondition;
- (NSString *)surveyItemText;
- (NSString *)surveyItemDefaultResponse;
- (NSString *)surveyItemDisplayType;
- (NSString *)surveyItemDisplayLabel;
- (NSString *)surveyItemMin;
- (NSString *)surveyItemMax;
- (NSString *)surveyItemMinChoices;
- (NSString *)surveyItemMaxChoices;
- (NSString *)surveyItemMaxDimension;
- (NSString *)surveyItemMaxDuration;
- (NSArray *)surveyItemChoices;
- (BOOL)surveyItemIsSkippable;
- (BOOL)surveyItemWholeNumbersOnly;


@end
