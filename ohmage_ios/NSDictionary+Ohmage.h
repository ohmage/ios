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
@property (nonatomic, readonly) NSDictionary *surveyResponseMetadataLocation;
@property (nonatomic, readonly) NSDictionary *surveyResponseData;
@property (nonatomic, readonly) NSString *surveyResponseID;
@property (nonatomic, readonly) NSString *surveyResponseTimestamp;
@property (nonatomic, readonly) NSNumber *surveyResponseLatitude;
@property (nonatomic, readonly) NSNumber *surveyResponseLongitude;
@property (nonatomic, readonly) NSNumber *surveyResponseLocationAccuracy;
@property (nonatomic, readonly) NSNumber *surveyResponseLocationTimestamp;

@property (nonatomic, readonly) NSString *reminderID;

- (NSString *)authToken;
- (NSString *)refreshToken;
- (NSString *)userID;
- (NSString *)username;
- (NSString *)userFullName;

- (NSArray *)surveyDefinitions;
- (NSString *)surveySchemaName;
- (NSString *)surveySchemaVersion;
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
@property (nonatomic, copy) NSDictionary *surveyResponseMetadataLocation;
@property (nonatomic, copy) NSDictionary *surveyResponseData;
@property (nonatomic, copy) NSString *surveyResponseID;
@property (nonatomic, copy) NSString *surveyResponseTimestamp;
@property (nonatomic, copy) NSNumber *surveyResponseLatitude;
@property (nonatomic, copy) NSNumber *surveyResponseLongitude;
@property (nonatomic, copy) NSNumber *surveyResponseLocationAccuracy;
@property (nonatomic, copy) NSNumber *surveyResponseLocationTimestamp;

@property (nonatomic, copy) NSString *reminderID;

@end
