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

- (NSArray *)surveyItems
{
    return self[@"survey_items"];
}

- (NSString *)surveyItemTypeKey
{
    return self[@"survey_item_type"];
}

- (NSString *)surveyItemId
{
    return self[@"survey_item_id"];
}

- (NSString *)surveyItemCondition
{
    return self[@"condition"];
}

- (NSString *)surveyItemText
{
    return self[@"text"];
}

- (NSString *)surveyItemDefaultResponse
{
    return self[@"default_response"];
}

- (NSString *)surveyItemDisplayType
{
    return self[@"display_type"];
}

- (NSString *)surveyItemDisplayLabel
{
    return self[@"display_label"];
}

- (NSString *)surveyItemMin
{
    return self[@"min"];
}

- (NSString *)surveyItemMax
{
    return self[@"max"];
}

- (NSString *)surveyItemMinChoices
{
    return self[@"min_choices"];
}

- (NSString *)surveyItemMaxChoices
{
    return self[@"max_choices"];
}

- (NSString *)surveyItemMaxDimension
{
    return self[@"max_dimension"];
}

- (NSString *)surveyItemMaxDuration
{
    return self[@"max_duration"];
}

- (NSArray *)surveyItemChoices
{
    return self[@"choices"];
}

- (BOOL)surveyItemIsSkippable
{
    return self[@"skippable"];
}

- (BOOL)surveyItemWholeNumbersOnly
{
    return self[@"whole_numbers_only"];
}


@end
