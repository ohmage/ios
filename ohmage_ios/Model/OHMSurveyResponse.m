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
        NSLog(@"prompt response itemID: %@$$$$$", response.surveyItem.ohmID);
        if ([response.surveyItem.ohmID isEqualToString:itemID]) {
            NSLog(@"found response for itemID: %@$$$$", itemID);
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

- (void)parser:(OHMConditionParser *)parser didMatchOrExpr:(PKAssembly *)match
{
//    NSLog(@"did match ORExpr with stack size: %lu, match: %@", (unsigned long)[match.stack count], match);
    
    BOOL result = NO;
	id tok = [match pop]; // pop the terminal token
    if ([tok isKindOfClass:[OHMSurveyPromptResponse class]]) {
        result = [(OHMSurveyPromptResponse *)tok compareToConditionValue:nil withComparison:nil isRHS:NO];
    }
    else if([tok isKindOfClass:[NSNumber class]]) {
        result = ([(NSNumber *)tok doubleValue] != 0);
    }
    else if ([tok isKindOfClass:[NSString class]]) {
        if ([(NSString *)tok isEqualToString:@"NOT_DISPLAYED"]) {
            result = NO;
        }
        else if ([(NSString *)tok isEqualToString:@"SKIPPED"]) {
            result = NO;
        }
        else {
            result = YES;
        }
    }
    
    NSLog(@"did match OrExpr with result: %d, match: %@", result, match);
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
