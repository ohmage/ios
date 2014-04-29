#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptChoice.h"


@interface OHMSurveyPromptResponse ()

// Private interface goes here.

@end


@implementation OHMSurveyPromptResponse

@synthesize imageValue;
@synthesize videoURL;

- (void)initializeDefaultResonse
{
    OHMSurveyItem *item = self.surveyItem;
    if (item.defaultNumberResponse != nil) {
        self.numberValue = item.defaultNumberResponse;
    }
    
    if (item.defaultStringResponse != nil) {
        self.stringValue = item.defaultStringResponse;
    }
    
    for (OHMSurveyPromptChoice *choice in item.choices) {
        if (choice.isDefaultValue) {
            [self addSelectedChoicesObject:choice];
        }
    }
}

@end
