#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMConditionParser.h"
#import <PEGKit/PEGKit.h>


@interface OHMSurveyResponse ()

// Private interface goes here.

@end


@implementation OHMSurveyResponse

- (OHMSurveyPromptResponse *)promptResponseForItemID:(NSString *)itemID
{
    for (OHMSurveyPromptResponse *response in self.promptResponses) {
        if ([response.surveyItem.ohmID isEqualToString:itemID]) {
            return response;
        }
    }
    NSLog(@"failed to find response for item id: %@$$$", itemID);
    return nil;
}

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex
{
    if (itemIndex >= [self.survey.surveyItems count]) return NO;
    
    OHMSurveyItem *item = self.survey.surveyItems[itemIndex];
    NSString *condition = item.condition;
    NSLog(@"should show item at index: %ld, condition: %@", itemIndex, condition);
    if (condition == nil) return YES;
    
    OHMConditionParser *parser = [[OHMConditionParser alloc] initWithDelegate:self];
    
    NSError *err = nil;
    PKAssembly *result = [parser parseString:condition error:&err];
    
    if (!result) {
        if (err) NSLog(@"Parse error: %@", err);
        return NO;
    }
    else {
        NSLog(@"result: %@", result);
        
        NSNumber *n = [result pop];
        return [n boolValue];
    }
    
    
    return YES;
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
//    NSLog(@"did match ORExpr with stack size: %lu, match: %@", (unsigned long)[match.stack count], match);
    
	id tok = [match pop];
    BOOL result = [self evaluateToken:tok];
    
    NSLog(@"did match OrExpr with result: %d, match: %@", result, match);
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchAndExpr:(PKAssembly *)match
{
    //    NSLog(@"did match ORExpr with stack size: %lu, match: %@", (unsigned long)[match.stack count], match);
    
	id tok = [match pop];
    BOOL result = [self evaluateToken:tok];
    
    NSLog(@"did match AndExpr with result: %d, match: %@", result, match);
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchOrTerm:(PKAssembly *)match
{
    NSLog(@"did match ORterm with stack size: %lu, match: %@", (unsigned long)[match.stack count], match);
    
	id rhs = [match pop];
    id lhs = [match pop];
    
    BOOL result = NO;
    if (lhs != nil) {
        result = [self evaluateToken:lhs] || [self evaluateToken:rhs];
    }
    else {
        result = [self evaluateToken:rhs];
    }
    
    NSLog(@"did match ORterm with result: %d, match: %@", result, match);
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchAndTerm:(PKAssembly *)match
{
    NSLog(@"did match ANDterm with stack size: %lu, match: %@", (unsigned long)[match.stack count], match);
    
	id rhs = [match pop];
    id lhs = [match pop];
    
    BOOL result = NO;
    if (lhs != nil) {
        result = [self evaluateToken:lhs] && [self evaluateToken:rhs];
    }
    else {
        result = [self evaluateToken:rhs];
    }
    
    NSLog(@"did match ANDterm with result: %d, match: %@", result, match);
    [match push:[NSNumber numberWithBool:result]];
}

- (void)parser:(OHMConditionParser *)parser didMatchRelOpTerm:(PKAssembly *)match
{
    id rhs = [match pop];
    NSString  *op = [[match pop] stringValue];
    id lhs = [match pop];
    
    if (lhs == nil) {
        NSLog(@"pushing rhs: %@ for single term RelOp", rhs);
        [match push:rhs];
        return;
    }
    
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
    NSLog(@"lhs: %@, rhs: %@, op: %@ result: %d", lhs, rhs, op, result);
    [match push:[NSNumber numberWithBool:result]];
}


- (void)parser:(OHMConditionParser *)parser didMatchOhmID:(PKAssembly *)result
{
    NSLog(@"did match ID: %@", result);
    PKToken *promptIDToken = [result pop];
    OHMSurveyPromptResponse *matchedResponse = [self promptResponseForItemID:[promptIDToken stringValue]];
//    NSLog(@"promptID: %@, match: %@", promptIDToken, matchedResponse);
    [result push:matchedResponse];
//    NSLog(@"pushed prompt response onto result: %@", result);
}

@end
