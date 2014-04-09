//
//  OHMSurveyItemTypes.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyItemTypes.h"

@implementation OHMSurveyItemTypes

+ (OHMSurveyItemType)itemTypeForKey:(NSString *)key
{
    static NSDictionary *itemTypeDictionary;
    
    if (!itemTypeDictionary) {
        itemTypeDictionary = @{ @"message"        : @(OHMSurveyItemTypeMessage),
                                @"number_prompt" : @(OHMSurveyItemTypeNumberPrompt),
                                @"text_prompt" : @(OHMSurveyItemTypeTextPrompt),
                                @"image_prompt" : @(OHMSurveyItemTypeImagePrompt),
                                @"audio_prompt"   : @(OHMSurveyItemTypeAudioPrompt),
                                @"video_prompt" : @(OHMSurveyItemTypeVideoPrompt),
                                @"timestamp_prompt" : @(OHMSurveyItemTypeTimestampPrompt),
                                @"number_single_choice_prompt" : @(OHMSurveyItemTypeNumberSingleChoicePrompt),
                                @"number_multi_choice_prompt" : @(OHMSurveyItemTypeNumberMultiChoicePrompt),
                                @"string_single_choice_prompt" : @(OHMSurveyItemTypeStringSingleChoicePrompt),
                                @"string_multi_choice_prompt" : @(OHMSurveyItemTypeStringMultiChoicePrompt),
                                @"remote_activity_prompt" : @(OHMSurveyItemTypeRemoteActivityPrompt) };
    }
    
    NSNumber *typeNumber = itemTypeDictionary[key];
    
    if (typeNumber) {
        return [typeNumber intValue];
    }
    else {
        return OHMSurveyItemTypeUnknown;
    }
}

@end
