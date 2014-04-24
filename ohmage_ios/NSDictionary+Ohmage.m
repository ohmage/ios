//
//  NSDictionary+Ohmage.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "NSDictionary+Ohmage.h"

@implementation NSDictionary (Ohmage)



- (id)nonNullValueForKey:(NSString *)key
{
    id value = self[key];
    if (value == [NSNull null]) {
        return nil;
    }
    else {
        return value;
    }
}

-(NSString *)authToken
{
    return [self nonNullValueForKey:@"access_token"];
}

- (NSString *)refreshToken
{
    return [self nonNullValueForKey:@"refresh_token"];
}

- (NSString *)userID
{
    return [self nonNullValueForKey:@"user_id"];
}

- (NSString *)userFullName
{
    return [self nonNullValueForKey:@"full_name"];
}

- (NSArray *)ohmlets
{
    return [self nonNullValueForKey:@"ohmlets"];
}

- (NSString *)ohmletID
{
    return [self nonNullValueForKey:@"ohmlet_id"];
}

- (NSString *)ohmletName
{
    return [self nonNullValueForKey:@"name"];
}

- (NSString *)ohmletDescription
{
    return [self nonNullValueForKey:@"description"];
}

- (NSArray *)surveyDefinitions
{
    return [self nonNullValueForKey:@"surveys"];
}

- (NSString *)surveyID
{
    return [self nonNullValueForKey:@"schema_id"];
}

- (NSInteger)surveyVersion
{
    NSNumber *versionNumber = [self nonNullValueForKey:@"schema_version"];
    if (versionNumber != nil) {
        return [versionNumber integerValue];
    }
    else {
        return -1;
    }
}

- (NSString *)surveyName
{
    return [self nonNullValueForKey:@"name"];
}

- (NSString *)surveyDescription
{
    return [self nonNullValueForKey:@"description"];
}

- (NSArray *)surveyItems
{
    return [self nonNullValueForKey:@"survey_items"];
}

- (NSString *)surveyItemTypeKey
{
    return [self nonNullValueForKey:@"survey_item_type"];
}

- (NSString *)surveyItemID
{
    return [self nonNullValueForKey:@"survey_item_id"];
}

- (NSString *)surveyItemCondition
{
    return [self nonNullValueForKey:@"condition"];
}

- (NSString *)surveyItemText
{
    return [self nonNullValueForKey:@"text"];
}

- (NSString *)surveyItemDefaultStringResponse
{
    return [self nonNullValueForKey:@"default_response"];
}

- (NSNumber *)surveyItemDefaultNumberResponse
{
    return [self nonNullValueForKey:@"default_response"];
}

- (NSArray *)surveyItemDefaultChoiceValues
{
    id response = [self nonNullValueForKey:@"default_response"];
    if (response) {
        if ([[response class] isSubclassOfClass:[NSArray class]]) {
            return response;
        }
        else {
            return @[response];
        }
    }
    else {
        return nil;
    }
}

- (NSString *)surveyItemDisplayType
{
    return [self nonNullValueForKey:@"display_type"];
}

- (NSString *)surveyItemDisplayLabel
{
    return [self nonNullValueForKey:@"display_label"];
}

- (NSNumber *)surveyItemMin
{
    return [self nonNullValueForKey:@"min"];
}

- (NSNumber *)surveyItemMax
{
    return [self nonNullValueForKey:@"max"];
}

- (NSString *)surveyItemMinChoices
{
    return [self nonNullValueForKey:@"min_choices"];
}

- (NSString *)surveyItemMaxChoices
{
    return [self nonNullValueForKey:@"max_choices"];
}

- (NSNumber *)surveyItemMaxDimension
{
    return [self nonNullValueForKey:@"max_dimension"];
}

- (NSNumber *)surveyItemMaxDuration
{
    return [self nonNullValueForKey:@"max_duration"];
}

- (NSArray *)surveyItemChoices
{
    return [self nonNullValueForKey:@"choices"];
}

- (NSNumber *)surveyItemIsSkippable
{
    return [self nonNullValueForKey:@"skippable"];
}

- (NSNumber *)surveyItemWholeNumbersOnly
{
    return [self nonNullValueForKey:@"whole_numbers_only"];
}


- (NSString *)surveyPromptChoiceText
{
    return [self nonNullValueForKey:@"text"];
}

- (NSString *)surveyPromptChoiceStringValue
{
    return [self nonNullValueForKey:@"value"];
}

- (NSNumber *)surveyPromptChoiceNumberValue
{
    return [self nonNullValueForKey:@"value"];
}


@end
