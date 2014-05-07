//
//  OHMPromptCondition.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMPromptCondition : NSObject

+ (void)test;

- (instancetype)initWithConditionString:(NSString *)conditionString;

@end
