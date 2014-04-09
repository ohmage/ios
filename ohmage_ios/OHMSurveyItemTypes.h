//
//  OHMSurveyItemTypes.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OHMSurveyItemTypeMessage,
    OHMSurveyItemTypeNumberPrompt,
    OHMSurveyItemTypeTextPrompt,
    OHMSurveyItemTypeImagePrompt,
    OHMSurveyItemTypeAudioPrompt,
    OHMSurveyItemTypeVideoPrompt,
    OHMSurveyItemTypeTimestampPrompt,
    OHMSurveyItemTypeNumberSingleChoicePrompt,
    OHMSurveyItemTypeNumberMultiChoicePrompt,
    OHMSurveyItemTypeStringSingleChoicePrompt,
    OHMSurveyItemTypeStringMultiChoicePrompt,
    OHMSupportedSurveyItemTypeCount,
    
    OHMSurveyItemTypeRemoteActivityPrompt, // not supported on iOS
    OHMSurveyItemTypeUnknown
} OHMSurveyItemType;

@interface OHMSurveyItemTypes : NSObject

+ (OHMSurveyItemType)itemTypeForKey:(NSString *)key;

@end
