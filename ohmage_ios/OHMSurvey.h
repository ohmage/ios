//
//  OHMSurvey.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMProject;

@interface OHMSurvey : NSObject

@property (nonatomic, readonly) OHMProject *project;
@property (nonatomic, copy) NSString *surveyID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *prompts;

@end
