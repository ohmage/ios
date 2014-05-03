//
//  OHMSurveyResponseViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/2/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseTableViewController.h"

@class OHMSurveyResponse;

@interface OHMSurveyResponseViewController : OHMBaseTableViewController

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)response;

- (void)setupSubmitHeader;

@end
