//
//  OHMConditionParserDelegate.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMSurveyResponse;

@interface OHMConditionParserDelegate : NSObject

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)surveyResponse;
- (BOOL)evaluateConditionString:(NSString *)conditionString;

@end
