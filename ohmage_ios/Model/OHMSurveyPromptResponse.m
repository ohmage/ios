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

- (void)didSave
{
    NSLog(@"prompt response did save: %@", [self description]);
    
    if (self.skippedValue) return;
    
    if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt) {
        [[OHMMediaStore sharedStore] setImage:self.imageValue forKey:[[self.objectID URIRepresentation] absoluteString]];
    }
    else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) {
        [[OHMMediaStore sharedStore] setVideoWithURL:self.videoURL forKey:[[self.objectID URIRepresentation] absoluteString]];
    }
}

- (NSURL *)videoURL
{
    if (_videoURL == nil) {
        _videoURL = [[OHMMediaStore sharedStore] videoURLForKey:[[self.objectID URIRepresentation] absoluteString]];
    }
    return _videoURL;
}

- (UIImage *)imageValue
{
    if (_imageValue == nil) {
        _imageValue = [[OHMMediaStore sharedStore] imageForKey:[[self.objectID URIRepresentation] absoluteString]];
    }
    return _imageValue;
}

@end
