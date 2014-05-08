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

- (NSArray *)valArray
{
    NSMutableArray *valArray = [NSMutableArray arrayWithCapacity:self.selectedChoices.count];
    [self.selectedChoices enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeNumberMultiChoicePrompt) {
            [valArray addObject:[(OHMSurveyPromptChoice *)obj numberValue]];
        }
        else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeNumberMultiChoicePrompt) {
            [valArray addObject:[(OHMSurveyPromptChoice *)obj stringValue]];
        }
    }];
    return valArray;
}

- (id)jsonVal
{
    if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeMessage) {
        return nil;
    }
    
    if (self.skippedValue) {
        return @"SKIPPED";
    }
    else if (self.notDisplayedValue) {
        return @"NOT_DISPLAYED";
    }
    else {
        switch (self.surveyItem.itemTypeValue) {
            case OHMSurveyItemTypeNumberPrompt:
                return self.numberValue;
            case OHMSurveyItemTypeTextPrompt:
                return self.stringValue;
            case OHMSurveyItemTypeNumberSingleChoicePrompt:
                return ((OHMSurveyPromptChoice *)self.selectedChoices.anyObject).numberValue;
            case OHMSurveyItemTypeStringSingleChoicePrompt:
                return ((OHMSurveyPromptChoice *)self.selectedChoices.anyObject).stringValue;
            case OHMSurveyItemTypeNumberMultiChoicePrompt:
            case OHMSurveyItemTypeStringMultiChoicePrompt:
                return [self valArray];
            default:
                return nil;
        }
    }
}

@end
