//
//  OHMSurveyItemViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OHMSurveyResponse;

@interface OHMSurveyItemViewController : UIViewController

+ (instancetype)viewControllerForSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index;

@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;
@property (nonatomic) NSInteger itemIndex;

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index;

@end
