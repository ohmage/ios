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
        return [(OHMSurveyPromptResponse *)token compareToConditionValue:nil withComparison:nil isRHS:NO];
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
        result = [(OHMSurveyPromptResponse *)lhs compareToConditionValue:rhs withComparison:op isRHS:NO];
    }
    else if ([rhs isKindOfClass:[OHMSurveyPromptResponse class]]) {
        result = [(OHMSurveyPromptResponse *)rhs compareToConditionValue:lhs withComparison:op isRHS:YES];
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

@end
