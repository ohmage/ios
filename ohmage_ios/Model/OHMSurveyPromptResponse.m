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

- (BOOL)compareToNumber:(NSNumber *)number withComparison:(NSString *)comparison
{
    double val = [number doubleValue];
    if ([comparison isEqualToString:@"<"]) {
        
    }
    return NO;
}

- (BOOL)compareToString:(NSString *)string withComparison:(NSString *)comparison
{
    
    return NO;
}

- (BOOL)compareToConditionValue:(id)value withComparison:(NSString *)comparison
{
    if ([value isKindOfClass:[NSString class]]) {
        
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
            return [self compareToNumber:value withComparison:comparison];
        }
    }
    else if ([value isKindOfClass:[self class]]) {
        return [((OHMSurveyPromptResponse *)value).promptResponseKey isEqualToString:self.promptResponseKey];
    }
    else {
        return NO;
    }
    
    return NO;
}

- (id)conditionValue
{
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeMessage:
            return self.surveyItem.text;
        case OHMSurveyItemTypeNumberPrompt:
            return self.numberValue;
        case OHMSurveyItemTypeTextPrompt:
            return self.stringValue;
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            return nil;//[self choiceConditionValue];
        default:
            return nil;
    }
}

@end
