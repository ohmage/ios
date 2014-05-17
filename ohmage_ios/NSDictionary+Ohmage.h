//
//  NSDictionary+Ohmage.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ohmage)

@property (nonatomic, readonly) NSArray *jsonArray;

@property (nonatomic, readonly) NSDictionary *surveyResponseMetadata;
@property (nonatomic, readonly) NSDictionary *surveyResponseData;
@property (nonatomic, readonly) NSString *surveyResponseID;
@property (nonatomic, readonly) NSString *surveyResponseTimestamp;

@property (nonatomic, readonly) NSString *reminderID;

- (NSString *)authToken;
- (NSString *)refreshToken;
- (NSString *)userID;
- (NSString *)username;
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


@interface NSMutableDictionary (Ohmage)

@property (nonatomic, copy) NSDictionary *surveyResponseMetadata;
@property (nonatomic, copy) NSDictionary *surveyResponseData;
@property (nonatomic, copy) NSString *surveyResponseID;
@property (nonatomic, copy) NSString *surveyResponseTimestamp;

@property (nonatomic, copy) NSString *reminderID;

@end
