//
//  OHMPromptCondition.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMPromptCondition.h"


NSString *const kAND = @"AND";
NSString *const kOR = @"OR";

NSString *const test1 = @"somePreviousPromptId == 3 AND anotherPreviousPromptId == \"Hello, world.\"";

NSString *const test2 = @"(somePreviousPromptId == 3) AND anotherPreviousPromptId == \"Hello, world.\"";

NSString *const test3 = @"(somePreviousPromptId == 3 AND somePreviousPromptId == \"Hello, world.\")";

static const NSRange kRangeNotFound = {NSNotFound, 0};


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

- (BOOL)fragmentIsNegated:(NSString *)fragment
{
    return NO;
}

- (BOOL)fragmentIsTerminal:(NSString *)fragment
{
    return NO;
}

- (BOOL)fragmentIsComparison:(NSString *)fragment
{
    return NO;
}

- (BOOL)fragmentIsConjunction:(NSString *)fragment
{
    return NO;
}

- (BOOL)evaluateNegatedFragment:(NSString *)fragment
{
    return NO;
}

- (BOOL)evaluateTerminalFragment:(NSString *)fragment
{
    return NO;
}

- (BOOL)evaluateComparisonFragment:(NSString *)fragment
{
    return NO;
}

- (BOOL)evaluateConjunctionFragment:(NSString *)fragment
{
    return NO;
}

- (BOOL)recursivelyEvaluateFragment:(NSString *)fragment
{
    if ([self fragmentIsNegated:fragment]) {
        return [self evaluateTerminalFragment:fragment];
    }
    else if ([self fragmentIsTerminal:fragment]) {
        return [self evaluateTerminalFragment:fragment];
    }
    else if ([self fragmentIsComparison:fragment]) {
        return [self evaluateComparisonFragment:fragment];
    }
    else if ([self fragmentIsConjunction:fragment]) {
        return [self evaluateConjunctionFragment:fragment];
    }
    else {
        NSAssert(0, @"failed to parse fragment: %@", fragment);
    }
    
    return  NO;
}

- (BOOL)parseConditionString:(NSString *)conditionString
{
    
    
    return NO;
}

@end
