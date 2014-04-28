#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"


@interface OHMSurveyResponse ()

// Private interface goes here.

@end


@implementation OHMSurveyResponse

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex
{
    if (itemIndex >= [self.survey.surveyItems count]) return NO;
    
    OHMSurveyItem *item = self.survey.surveyItems[itemIndex];
    
    return YES;
}

@end
