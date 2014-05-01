//
//  OHMSurveyItemViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseViewController.h"

@class OHMSurveyResponse;

@interface OHMSurveyItemViewController : OHMBaseViewController

+ (instancetype)viewControllerForSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index;

@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;
@property (nonatomic) NSInteger itemIndex;
@property (nonatomic, strong) UIViewController *startingViewController;

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index;

@end
