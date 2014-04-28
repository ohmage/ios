//
//  OHMPromptCondition.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMPromptCondition.h"


NSString *const kCon = @"stuckPointLogInstructions";



@interface OHMPromptCondition ()

@property (nonatomic, copy) NSString *conditionString;

@end

@implementation OHMPromptCondition

- (instancetype)initWithConditionString:(NSString *)conditionString
{
    self = [super init];
    if (self) {
        self.conditionString = conditionString;
        
    }
    return self;
}

- (BOOL)parseConditionString:(NSString *)conditionString
{
    
    
    return NO;
}

@end
