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
- (NSString *)userID;
- (NSString *)userFullName;

- (NSArray *)ohmlets;
- (NSString *)ohmletID;
- (NSString *)ohmletName;
- (NSString *)ohmletDescription;

- (NSArray *)surveyDefinitions;
- (NSString *)surveyID;
- (NSInteger)surveyVersion;
- (NSString *)surveyName;
- (NSString *)surveyDescription;
- (NSArray *)surveyItems;

- (NSString *)surveyItemTypeKey;
- (NSString *)surveyItemID;
- (NSString *)surveyItemCondition;
- (NSString *)surveyItemText;
- (NSString *)surveyItemDefaultStringResponse;
- (NSNumber *)surveyItemDefaultNumberResponse;
- (NSArray *)surveyItemDefaultChoiceValues;
- (NSString *)surveyItemDisplayType;
- (NSString *)surveyItemDisplayLabel;
- (NSNumber *)surveyItemMin;
- (NSNumber *)surveyItemMax;
- (NSNumber *)surveyItemMinChoices;
- (NSNumber *)surveyItemMaxChoices;
- (NSNumber *)surveyItemMaxDimension;
- (NSNumber *)surveyItemMaxDuration;
- (NSArray *)surveyItemChoices;
- (NSNumber *)surveyItemIsSkippable;
- (NSNumber *)surveyItemWholeNumbersOnly;

- (NSString *)surveyPromptChoiceText;
- (NSString *)surveyPromptChoiceStringValue;
- (NSNumber *)surveyPromptChoiceNumberValue;


@end
