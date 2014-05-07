#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptChoice.h"
#import "OHMMediaStore.h"


@interface OHMSurveyPromptResponse ()

// Private interface goes here.

@end


@implementation OHMSurveyPromptResponse

@synthesize imageValue=_imageValue;
@synthesize videoURL=_videoURL;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.promptResponseKey = key;
}


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

//- (void)didSave
//{
//    NSLog(@"prompt response did save: %@", [self description]);
//    
//    if (self.skippedValue) return;
//    
//    if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt) {
//        [[OHMMediaStore sharedStore] setImage:self.imageValue forKey:[[self.objectID URIRepresentation] lastPathComponent]];
//    }
//    else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) {
//        [[OHMMediaStore sharedStore] setVideoWithURL:self.videoURL forKey:[[self.objectID URIRepresentation] lastPathComponent]];
//    }
//}

- (void)prepareForDeletion
{
    if (self.skippedValue) return;
    
    if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt) {
        [[OHMMediaStore sharedStore] deleteImageForKey:self.promptResponseKey];
    }
    else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) {
        [[OHMMediaStore sharedStore] deleteVideoForKey:self.promptResponseKey];
    }

}

- (NSURL *)videoURL
{
    if (_videoURL == nil) {
        _videoURL = [[OHMMediaStore sharedStore] videoURLForKey:self.promptResponseKey];
    }
    return _videoURL;
}

- (void)setVideoURL:(NSURL *)videoURL
{
    _videoURL = videoURL;
    if (videoURL) {
        [[OHMMediaStore sharedStore] setVideoWithURL:videoURL forKey:self.promptResponseKey];
    }
    else {
        [[OHMMediaStore sharedStore] deleteVideoForKey:self.promptResponseKey];
    }
}

- (UIImage *)imageValue
{
    if (_imageValue == nil) {
        _imageValue = [[OHMMediaStore sharedStore] imageForKey:self.promptResponseKey];
    }
    return _imageValue;
}

- (void)setImageValue:(UIImage *)imageValue
{
    _imageValue = imageValue;
    if (imageValue) {
        [[OHMMediaStore sharedStore] setImage:imageValue forKey:self.promptResponseKey];
    }
    else {
        [[OHMMediaStore sharedStore] deleteImageForKey:self.promptResponseKey];
    }
}
//
//- (id)choiceConditionValue
//{
//    for (OHMSurveyPromptChoice *choice in self.selectedChoices) {
//        if (choice.stringValue != nil) {};
//    }
//}

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

- (BOOL)compareToNumber:(NSNumber *)number withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    NSNumber *lhNumber = nil;
    NSNumber *rhNumber = nil;
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeNumberPrompt:
            lhNumber = isRHS ? number : self.numberValue;
            rhNumber = isRHS ? self.numberValue : number;
            return [self compareLHNumber:lhNumber toRHNumber:rhNumber withComparison:comparison];
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
            for (OHMSurveyPromptChoice *choice in self.selectedChoices) {
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

- (BOOL)compareToString:(NSString *)string withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    if ([string isEqualToString:@"SKIPPED"]) {
        return [self compareFlagValue:self.skippedValue withComparison:comparison];
    }
    else if ([string isEqualToString:@"NOT_DISPLAYED"]) {
        return [self compareFlagValue:self.notDisplayedValue withComparison:comparison];
    }
    
    NSString *lhString = nil;
    NSString *rhString = nil;
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeTextPrompt:
            lhString = isRHS ? string : self.stringValue;
            rhString = isRHS ? self.stringValue : string;
            return [self compareLHString:lhString toRHString:rhString withComparison:comparison];
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            for (OHMSurveyPromptChoice *choice in self.selectedChoices) {
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

- (BOOL)compareToConditionValue:(id)value withComparison:(NSString *)comparison isRHS:(BOOL)isRHS
{
    if (value == nil) {
        return !self.skippedValue && !self.notDisplayedValue;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return [self compareToString:value withComparison:comparison isRHS:isRHS];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        return [self compareToNumber:value withComparison:comparison isRHS:isRHS];
    }
    else if ([value isKindOfClass:[self class]]) {
        return [((OHMSurveyPromptResponse *)value).promptResponseKey isEqualToString:self.promptResponseKey];
    }
    else {
        return NO;
    }
}

@end
