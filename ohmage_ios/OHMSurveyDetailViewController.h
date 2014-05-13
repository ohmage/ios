//
//  OHMSurveyDetailViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseTableViewController.h"

@class OHMSurvey;

@interface OHMSurveyDetailViewController : OHMBaseTableViewController

- (instancetype)initWithSurvey:(OHMSurvey *)survey;

@end
