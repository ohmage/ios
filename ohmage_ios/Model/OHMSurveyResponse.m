#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMConditionParserDelegate.h"


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
    return nil;
}

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex
{
    if (itemIndex >= [self.survey.surveyItems count]) return NO;
    
    OHMSurveyItem *item = self.survey.surveyItems[itemIndex];
    NSString *condition = item.condition;
    
    if (condition == nil) return YES;
    
    OHMConditionParserDelegate *conditionDelegate = [[OHMConditionParserDelegate alloc] initWithSurveyResponse:self];
    
    return [conditionDelegate evaluateConditionString:condition];
}


@end
