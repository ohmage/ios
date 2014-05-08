//
//  OHMConditionParserDelegate.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMConditionParserDelegate.h"
#import "OHMSurveyResponse.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptChoice.h"
#import "OHMConditionParser.h"
#import <PEGKit/PEGKit.h>

@interface OHMConditionParserDelegate ()

@property (nonatomic, strong) OHMSurveyResponse *surveyResponse;

@end

@implementation OHMConditionParserDelegate

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)surveyResponse
{
    self = [super init];
    if (self) {
        self.surveyResponse = surveyResponse;
    }
    return self;
}

- (BOOL)evaluateConditionString:(NSString *)conditionString
{
    OHMConditionParser *parser = [[OHMConditionParser alloc] initWithDelegate:self];
    
    NSError *err = nil;
    PKAssembly *result = [parser parseString:conditionString error:&err];
    
    if (!result) {
        if (err) NSLog(@"Parse error: %@", err);
        return NO;
    }
    else {
        NSNumber *resultValue = [result pop];
        return [resultValue boolValue];
    }
}

- (BOOL)evaluateToken:(id)token
{
    if ([token isKindOfClass:[OHMSurveyPromptResponse class]]) {
        return [self comparePromptResponse:token toConditionValue:nil withComparison:nil isRHS:NO];
    }
    else if([token isKindOfClass:[NSNumber class]]) {
        return ([(NSNumber *)token doubleValue] != 0);
    }
    else if ([token isKindOfClass:[NSString class]]) {
        if ([(NSString *)token isEqualToString:@"NOT_DISPLAYED"]) {
            return NO;
        }
        else if ([(NSString *)token isEqualToString:@"SKIPPED"]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return NO;
    }
}

- (void)parser:(OHMConditionParser *)parser didMatchOrExpr:(PKAssembly *)match
{
	id tok = [match pop];
    BOOL result = [self evaluateToken:tok];
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchAndExpr:(PKAssembly *)match
{
	id tok = [match pop];
    BOOL result = [self evaluateToken:tok];
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchOrTerm:(PKAssembly *)match
{
	id rhs = [match pop];
    id lhs = [match pop];
    
    BOOL result = NO;
    if (lhs != nil) {
        result = [self evaluateToken:lhs] || [self evaluateToken:rhs];
    }
    else {
        result = [self evaluateToken:rhs];
    }
    
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchAndTerm:(PKAssembly *)match
{
	id rhs = [match pop];
    id lhs = [match pop];
    
    BOOL result = NO;
    if (lhs != nil) {
        result = [self evaluateToken:lhs] && [self evaluateToken:rhs];
    }
    else {
        result = [self evaluateToken:rhs];
    }
    
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchRelOpTerm:(PKAssembly *)match
{
    id rhs = [match pop];
    NSString  *op = [[match pop] stringValue];
    id lhs = [match pop];
    
    BOOL result = NO;
    if ([lhs isKindOfClass:[OHMSurveyPromptResponse class]]) {
        result = [self comparePromptResponse:lhs toConditionValue:rhs withComparison:op isRHS:NO];
    }
    else if ([rhs isKindOfClass:[OHMSurveyPromptResponse class]]) {
        result = [self comparePromptResponse:rhs toConditionValue:lhs withComparison:op isRHS:YES];
    }
    else if ([rhs isKindOfClass:[NSString class]] && [lhs isKindOfClass:[NSString class]]) {
        NSString *rhString = (NSString *)rhs;
        NSString *lhString = (NSString *)lhs;
        if (EQ(op, @"<"))  result = ([lhString compare:rhString] == NSOrderedAscending);
        else if (EQ(op, @">"))  result = ([lhString compare:rhString] == NSOrderedDescending);
        else if (EQ(op, @"==")) result = [lhString isEqualToString:rhString];
        else if (EQ(op, @"!=")) result = ![lhString isEqualToString:rhString];
        else if (EQ(op, @"<=")) result = ( ([lhString compare:rhString] == NSOrderedAscending)
                                          || ([lhString compare:rhString] == NSOrderedSame) );
        else if (EQ(op, @">=")) result = ( ([lhString compare:rhString] == NSOrderedDescending)
                                          || ([lhString compare:rhString] == NSOrderedSame) );
    }
    else if ([rhs isKindOfClass:[NSNumber class]] && [lhs isKindOfClass:[NSNumber class]]) {
        double rhNumber = ((NSNumber *)rhs).doubleValue;
        double lhNumber = ((NSNumber *)lhs).doubleValue;
        if (EQ(op, @"<"))  result = (lhNumber <  rhNumber);
        else if (EQ(op, @">"))  result = (lhNumber >  rhNumber);
        else if (EQ(op, @"==")) result = (lhNumber == rhNumber);
        else if (EQ(op, @"!=")) result = (lhNumber != rhNumber);
        else if (EQ(op, @"<=")) result = (lhNumber <= rhNumber);
        else if (EQ(op, @">=")) result = (lhNumber >= rhNumber);
    }
    
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchOhmID:(PKAssembly *)result
{
    PKToken *promptIDToken = [result pop];
    OHMSurveyPromptResponse *matchedResponse = [self.surveyResponse promptResponseForItemID:[promptIDToken stringValue]];
    [result push:matchedResponse];
}


# pragma mark - Prompt Response Comparison

- (BOOL)compareLHNumber:(NSNumber *)lhNumber toRHNumber:(NSNumber *)rhNumber withComparison:(NSString *)comparison
{
    double rhs = rhNumber.doubleValue;
    double lhs = lhNumber.doubleValue;
    BOOL result = NO;
    if ([comparison isEqualToString:@"<"])  result = (lhs < rhs);
    else if ([comparison isEqualToString:@">"])  result = (lhs > rhs);
    else if ([comparison isEqualToString:@"=="]) result = (lhs == rhs);
    else if ([comparison isEqualToString:@"!="]) result = (lhs != rhs);
    else if ([comparison isEqualToString:@"<="]) result = (lhs <= rhs);
    else if ([comparison isEqualToString:@">="]) result = (lhs >= rhs);
    
    return result;
}

- (BOOL)comparePromptResponse:(OHMSurveyPromptResponse *)promptResponse toNumber:(NSNumber *)number withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    NSNumber *lhNumber = nil;
    NSNumber *rhNumber = nil;
    switch (promptResponse.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeNumberPrompt:
            lhNumber = isRHS ? number : promptResponse.numberValue;
            rhNumber = isRHS ? promptResponse.numberValue : number;
            return [self compareLHNumber:lhNumber toRHNumber:rhNumber withComparison:comparison];
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
            for (OHMSurveyPromptChoice *choice in promptResponse.selectedChoices) {
                lhNumber = isRHS ? number : choice.numberValue;
                rhNumber = isRHS ? choice.numberValue : number;
                if ([self compareLHNumber:lhNumber toRHNumber:rhNumber withComparison:comparison]) {
                    return YES;
                }
            }
            return NO;
        default:
            return NO;
    }
}

- (BOOL)compareLHString:(NSString *)lhString toRHString:(NSString *)rhString withComparison:(NSString *)comparison
{
    BOOL result = NO;
    if ([comparison isEqualToString:@"<"])  result = ([lhString compare:rhString] == NSOrderedAscending);
    else if ([comparison isEqualToString:@">"])  result = ([lhString compare:rhString] == NSOrderedDescending);
    else if ([comparison isEqualToString:@"=="]) result = [lhString isEqualToString:rhString];
    else if ([comparison isEqualToString:@"!="]) result = ![lhString isEqualToString:rhString];
    else if ([comparison isEqualToString:@"<="]) result = ( ([lhString compare:rhString] == NSOrderedAscending)
                                                           || ([lhString compare:rhString] == NSOrderedSame) );
    else if ([comparison isEqualToString:@">="]) result = ( ([lhString compare:rhString] == NSOrderedDescending)
                                                           || ([lhString compare:rhString] == NSOrderedSame) );
    return result;
}

- (BOOL)compareFlagValue:(BOOL)flagValue withComparison:(NSString *)comparison
{
    if ([comparison isEqualToString:@"=="]) return flagValue;
    else if ([comparison isEqualToString:@"!="]) return !flagValue;
    else return NO;
}

- (BOOL)comparePromptResponse:(OHMSurveyPromptResponse *)promptResponse toString:(NSString *)string withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    if ([string isEqualToString:@"SKIPPED"]) {
        return [self compareFlagValue:promptResponse.skippedValue withComparison:comparison];
    }
    else if ([string isEqualToString:@"NOT_DISPLAYED"]) {
        return [self compareFlagValue:promptResponse.notDisplayedValue withComparison:comparison];
    }
    
    NSString *lhString = nil;
    NSString *rhString = nil;
    switch (promptResponse.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeTextPrompt:
            lhString = isRHS ? string : promptResponse.stringValue;
            rhString = isRHS ? promptResponse.stringValue : string;
            return [self compareLHString:lhString toRHString:rhString withComparison:comparison];
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            for (OHMSurveyPromptChoice *choice in promptResponse.selectedChoices) {
                lhString = isRHS ? string : choice.stringValue;
                rhString = isRHS ? choice.stringValue : string;
                if ([self compareLHString:lhString toRHString:rhString withComparison:comparison]) {
                    return YES;
                }
            }
            return NO;
        default:
            return NO;
    }
}

- (BOOL)comparePromptResponse:(OHMSurveyPromptResponse *)promptResponse toConditionValue:(id)value withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    if (value == nil) {
        return !promptResponse.skippedValue && !promptResponse.notDisplayedValue;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [self comparePromptResponse:promptResponse toString:value withComparison:comparison isRHS:isRHS];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        return [self comparePromptResponse:promptResponse toNumber:value withComparison:comparison isRHS:isRHS];
    }
    else if ([value isKindOfClass:[self class]]) {
        return [((OHMSurveyPromptResponse *)value).promptResponseKey isEqualToString:promptResponse.promptResponseKey];
    }
    else {
        return NO;
    }
}


@end
