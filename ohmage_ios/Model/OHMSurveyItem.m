#import "OHMSurveyItem.h"
#import "NSDictionary+Ohmage.h"
#import "OHMSurveyItemTypes.h"
#import "OHMSurveyPromptChoice.h"


@interface OHMSurveyItem ()

// Private interface goes here.

@end


@implementation OHMSurveyItem

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

//+ (NSDictionary *)valuesDictionaryFromJSONDefinition:(NSDictionary *)definition
//{
//    NSMutableDictionary *values = [NSMutableDictionary dictionary];
//    values[@"condition"] = [definition surveyItemCondition];
//    values[@"defaultResponse"] = [definition surveyItemDefaultResponse];
//    values[@"displayLabel"] = [definition surveyItemDisplayLabel];
//    values[@"itemType"] = @([OHMSurveyItemTypes itemTypeForKey:[definition surveyItemTypeKey]]);
//    values[@"max"] = [definition surveyItemMax];
//    values[@"maxChoices"] = [definition surveyItemMaxChoices];
//    values[@"maxDimension"] = [definition surveyItemMaxDimension];
//    values[@"maxDuration"] = [definition surveyItemMaxDuration];
//    values[@"min"] = [definition surveyItemMin];
//    values[@"minChoices"] = [definition surveyItemMinChoices];
//    values[@"ohmID"] = [definition surveyItemID];
//    values[@"skippable"] = @([definition surveyItemIsSkippable]);
//    values[@"text"] = [definition surveyItemText];
//    values[@"wholeNumbersOnly"] = @([definition surveyItemWholeNumbersOnly]);
//    
//    return values;
//}

//+ (instancetype)itemWithDefinition:(NSDictionary *)itemDefinition
//{
//    return [[self alloc] initWithDefinition:itemDefinition];
//}
//
//- (instancetype)initWithDefinition:(NSDictionary *)itemDefinition
//{
//    OHMSurveyItemType itemType = [OHMSurveyItemTypes itemTypeForKey:[itemDefinition surveyItemTypeKey]];
//    
//    if (itemType >= OHMSupportedSurveyItemTypeCount) {
//        return nil;
//    }
//    
//    self = [super init];
//    if (self) {
//        [self setupItemOfType:itemType withDefinition:itemDefinition];
//    }
//    return self;
//}
//
//- (void)setupItemOfType:(OHMSurveyItemType)type withDefinition:(NSDictionary *)definition
//{
//    self.itemType = type;
//    self.itemId = [definition surveyItemId];
//    self.condition = [definition surveyItemCondition];
//    self.text = [definition surveyItemText];
//    
//    switch (type) {
//        case OHMSurveyItemTypeMessage:
//            [self setupMessageItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeNumberPrompt:
//            [self setupNumberPromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeTextPrompt:
//            [self setupTextPromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeImagePrompt:
//            [self setupImagePromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeAudioPrompt:
//            [self setupAudioPomptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeVideoPrompt:
//            [self setupVideoPromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeTimestampPrompt:
//            [self setupTimestampPromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeNumberSingleChoicePrompt:
//            [self setupNumberSingleChoicePromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeNumberMultiChoicePrompt:
//            [self setupNumberMultiChoicePromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeStringSingleChoicePrompt:
//            [self setupStringSingleChoicePromptItemWithDefinition:definition];
//            break;
//        case OHMSurveyItemTypeStringMultiChoicePrompt:
//            [self setupStringMultiChoicePromptItemWithDefinition:definition];
//            break;
//        default:
//            NSAssert(NO, @"OHMSurveyItem::setupItemOfType called with unknown type: %d", type);
//            break;
//    }
//}
//
//- (void)commonSetup:(NSDictionary *)definition
//{
//    self.displayType = [definition surveyItemDisplayType];
//    self.displayLabel = [definition surveyItemDisplayLabel];
//    self.skippable = [definition surveyItemIsSkippable];
//    self.defaultResponse = [definition surveyItemDefaultResponse];
//}
//
//- (void)setupMessageItemWithDefinition:(NSDictionary *)definition
//{
//}
//
//- (void)setupNumberPromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.min = [definition surveyItemMin];
//    self.max = [definition surveyItemMax];
//    self.wholeNumbersOnly = [definition surveyItemWholeNumbersOnly];
//}
//
//- (void)setupTextPromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.min = [definition surveyItemMin];
//    self.max = [definition surveyItemMax];
//}
//
//- (void)setupImagePromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.maxDimension = [definition surveyItemMaxDimension];
//}
//
//- (void)setupAudioPomptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.maxDuration = [definition surveyItemMaxDuration];
//}
//
//- (void)setupVideoPromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.maxDuration = [definition surveyItemMaxDuration];
//}
//
//- (void)setupTimestampPromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//}
//
//- (void)setupNumberSingleChoicePromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.choices = [definition surveyItemChoices];
//}
//
//- (void)setupNumberMultiChoicePromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.choices = [definition surveyItemChoices];
//    self.minChoices = [definition surveyItemMinChoices];
//    self.maxChoices = [definition surveyItemMaxChoices];
//}
//
//- (void)setupStringSingleChoicePromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.choices = [definition surveyItemChoices];
//}
//
//- (void)setupStringMultiChoicePromptItemWithDefinition:(NSDictionary *)definition
//{
//    [self commonSetup:definition];
//    self.choices = [definition surveyItemChoices];
//    self.minChoices = [definition surveyItemMinChoices];
//    self.maxChoices = [definition surveyItemMaxChoices];
//}

@end