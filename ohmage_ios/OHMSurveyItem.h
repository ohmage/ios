//
//  OHMSurveyItem.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMSurveyItemTypes.h"

@interface OHMSurveyItem : NSObject

+ (instancetype)itemWithDefinition:(NSDictionary *)itemDefinition;

@property (nonatomic) OHMSurveyItemType itemType;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *condition;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *defaultResponse;
@property (nonatomic, copy) NSString *displayType;
@property (nonatomic, copy) NSString *displayLabel;
@property (nonatomic, copy) NSString *min;
@property (nonatomic, copy) NSString *max;
@property (nonatomic, copy) NSString *maxDimension;
@property (nonatomic, copy) NSString *maxDuration;
@property (nonatomic, copy) NSString *minChoices;
@property (nonatomic, copy) NSString *maxChoices;

@property (nonatomic, strong) NSArray *choices;

@property (nonatomic) BOOL skippable;
@property (nonatomic) BOOL wholeNumbersOnly;

@end
