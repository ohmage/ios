//
//  OHMOhmage.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/3/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMSurvey.h"

@class OHMOhmlet;
@protocol OHMOhmageDelegate;

@interface OHMOhmage : NSObject

@property (nonatomic, weak) id<OHMOhmageDelegate> delegate;

+ (OHMOhmage*)sharedOhmage;

- (void)login;
- (NSArray *)ohmlets;
- (NSArray *)surveysForOhmlet:(OHMOhmlet *)ohmlet;
- (NSInteger)surveyCount;

@end

@protocol OHMOhmageDelegate <NSObject>
@optional
- (void)OHMOhmage:(OHMOhmage *)ohmage didRefreshSurveys:(NSArray *)surveys;
@end

