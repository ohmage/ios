//
//  OHMSurvey.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMSurveyItem.h"

@class OHMOhmlet;
@protocol OHMSurveyDelegate;

@interface OHMSurvey : OHMObject

@property (nonatomic, weak) id<OHMSurveyDelegate> delegate;

@property (nonatomic, copy) void (^surveyUpdatedBlock)(void);

@property (nonatomic) NSInteger surveyVersion;
@property (nonatomic, copy) NSString *surveyName;
@property (nonatomic, copy) NSString *surveyDescription;
@property (nonatomic, readonly) NSArray *surveyItems;
@property (nonatomic) BOOL isLoaded;

+ (instancetype)loadFromServerWithDefinition:(NSDictionary *)surveyDefinition;

@end


@protocol OHMSurveyDelegate <NSObject>
- (void)OHMSurveDidUpdate:(OHMSurvey *)survey;
@end