//
//  OHMSurvey.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMOhmlet;

@interface OHMSurvey : OHMObject

@property (nonatomic, readonly) OHMOhmlet *ohmlet;
@property (nonatomic) NSInteger surveyVersion;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *prompts;

+ (instancetype)loadFromServerWithDefinition:(NSDictionary *)surveyDefinition;

@end
