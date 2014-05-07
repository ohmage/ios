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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"surveyItem.ohmID == %@", itemID];
    NSOrderedSet *results = [self.promptResponses filteredOrderedSetUsingPredicate:predicate];
    if ([results count] > 0) {
        NSLog(@"found %lu responses. first: %@", (unsigned long)[results count], [results firstObject]);
        return [results firstObject];
    }
    else {
        NSLog(@"failed to find response for item id: %@", itemID);
        return nil;
    }
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

- (void)parser:(OHMConditionParser *)parser didMatchRelOpTerm:(PKAssembly *)match
{
    id rhs = [match pop];
    NSString  *op = [match pop];
    id lhs = [match pop];
    
    BOOL result = NO;
    if ([lhs isKindOfClass:[OHMSurveyPromptResponse class]]) {
        [(OHMSurveyPromptResponse *)lhs]
    }
    if ([rhs isKindOfClass:[NSString class]] && [lhs isKindOfClass:[NSString class]]) {
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
    NSLog(@"lhs: %@, rhs: %@, result: %d", lhs, rhs, result);
    PUSH_BOOL(result);
}


- (void)parser:(OHMConditionParser *)parser didMatchOhmID:(PKAssembly *)result
{
    NSLog(@"did match ID: %@", result);
    NSString *promptID = [result pop];
    OHMSurveyPromptResponse *matchedResponse = [self promptResponseForItemID:promptID];
    NSLog(@"promptID: %@, match: %@", promptID, matchedResponse);
    [result push:matchedResponse];
    
}

@end
