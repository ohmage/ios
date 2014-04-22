//
//  OHMSurveyPrompt.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int OHMSurveyPromptType;

enum OHMSurveyPromptType {
    OHMPromptTypeAudio = 0,
    OHMPromptTypeMultiChoice,
    OHMPromptTypeMultiChoiceCustom,
    OHMPromptTypeNumber,
    OHMPromptTypePhoto,
    OHMPromptTypeRemoteActivity,
    OHMPromptTypeSingleChoice,
    OHMPromptTypeSingleChoiceCustom,
    OHMPromptTypeText,
    OHMPromptTypeTimestamp,
    OHMPromptTypeVideo,
    OHMPromptTypeCount
};

@interface OHMSurveyPrompt : NSObject

@property (nonatomic, copy) NSString *promptID;
@property (nonatomic, copy) NSString *displayLabel;
@property (nonatomic, copy) NSString *promptText;
@property (nonatomic) OHMSurveyPromptType promptType;

@end
