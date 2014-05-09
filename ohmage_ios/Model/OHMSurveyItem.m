#import "OHMSurveyItem.h"
#import "NSDictionary+Ohmage.h"
#import "OHMSurveyItemTypes.h"
#import "OHMSurveyPromptChoice.h"


@interface OHMSurveyItem ()

// Private interface goes here.

@end


@implementation OHMSurveyItem

- (NSTimeInterval)maxDurationTimeInterval
{
    return self.maxDurationValue / 1000.0;
}

- (void)setValuesFromDefinition:(NSDictionary *)definition
{
    self.condition = [definition surveyItemCondition];
    self.displayLabel = [definition surveyItemDisplayLabel];
    self.itemTypeValue = [OHMSurveyItemTypes itemTypeForKey:[definition surveyItemTypeKey]];
    self.max = [definition surveyItemMax];
    self.maxChoices = [definition surveyItemMaxChoices];
    self.maxDimension = [definition surveyItemMaxDimension];
    self.maxDuration = [definition surveyItemMaxDuration];
    self.min = [definition surveyItemMin];
    self.minChoices = [definition surveyItemMinChoices];
    self.ohmID = [definition surveyItemID];
    self.skippable = [definition surveyItemIsSkippable];
    self.text = [definition surveyItemText];
    self.wholeNumbersOnly = [definition surveyItemWholeNumbersOnly];
    
    if (self.itemTypeValue == OHMSurveyItemTypeTextPrompt) {
        self.defaultStringResponse = [definition surveyItemDefaultStringResponse];
    }
    else if(self.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
        self.defaultNumberResponse = [definition surveyItemDefaultNumberResponse];
    }

}

- (BOOL)hasDefaultResponse
{
    if (self.defaultStringResponse != nil) return YES;
    if (self.defaultNumberResponse != nil) return YES;
    for (OHMSurveyPromptChoice *choice in self.choices) {
        if (choice.isDefaultValue) return YES;
    }
    return NO;
}

@end