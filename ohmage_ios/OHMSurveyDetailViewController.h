//
//  OHMSurveyDetailViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseViewController.h"

@class OHMSurvey;

@interface OHMSurveyDetailViewController : OHMBaseViewController

- (instancetype)initWithSurvey:(OHMSurvey *)survey;

- (void)popToNavigationRootAnimated;

@end
