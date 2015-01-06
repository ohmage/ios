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
@synthesize audioURL=_audioURL;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.uuid = [[[NSUUID alloc] init] UUIDString];
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
        [[OHMMediaStore sharedStore] deleteImageForKey:self.uuid];
    }
    else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) {
        [[OHMMediaStore sharedStore] deleteVideoForKey:self.uuid];
    }
    else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeAudioPrompt) {
        [[OHMMediaStore sharedStore] deleteAudioForKey:self.uuid];
    }

}

- (BOOL)hasValue
{
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeNumberPrompt:
            return self.numberValue != nil;
        case OHMSurveyItemTypeTextPrompt:
            return self.stringValue != nil;
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            return self.selectedChoices.count > 0;
        case OHMSurveyItemTypeTimestampPrompt:
            return self.timestampValue != nil;
        case OHMSurveyItemTypeImagePrompt:
        case OHMSurveyItemTypeVideoPrompt:
        case OHMSurveyItemTypeAudioPrompt:
            return self.hasMediaAttachment;
        default:
            return NO;
    }
}

- (BOOL)hasMediaAttachment
{
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
            return self.imageValue != nil;
        case OHMSurveyItemTypeAudioPrompt:
            return self.audioURL != nil;
        case OHMSurveyItemTypeVideoPrompt:
            return self.videoURL != nil;
            default:
        return NO;
    }
    
    return NO;
}

- (NSURL *)mediaAttachmentURL
{
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
            return [[OHMMediaStore sharedStore] imageURLForKey:self.uuid];
        case OHMSurveyItemTypeAudioPrompt:
            return self.audioURL;
        case OHMSurveyItemTypeVideoPrompt:
            return self.videoURL;
        default:
            return nil;
    }
    
    return nil;
}

- (NSString *)mediaAttachmentName
{
    return [[self mediaAttachmentURL] lastPathComponent];
}

- (NSString *)mimeType
{
    switch (self.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
            return @"image/jpeg";
        case OHMSurveyItemTypeAudioPrompt:
            return @"audio/mp4";
        case OHMSurveyItemTypeVideoPrompt:
            return @"video/mp4";
        default:
            return nil;
    }
    
    return nil;
}

- (NSURL *)videoURL
{
    if (_videoURL == nil) {
        _videoURL = [[OHMMediaStore sharedStore] videoURLForKey:self.uuid];
        BOOL isFile = [[NSFileManager defaultManager] fileExistsAtPath:[_videoURL path]];
        NSLog(@"file exists at path: %d, %@", isFile, [_videoURL path]);
    }
    return _videoURL;
}

- (void)setVideoURL:(NSURL *)videoURL
{
    // don't store temp path so media store can return permanent path
    _videoURL = nil;
    if (videoURL) {
        [[OHMMediaStore sharedStore] setVideoWithURL:videoURL forKey:self.uuid];
    }
    else {
        [[OHMMediaStore sharedStore] deleteVideoForKey:self.uuid];
    }
}

- (NSURL *)audioURL
{
    if (_audioURL == nil) {
        NSURL *url = [[OHMMediaStore sharedStore] audioURLForKey:self.uuid];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
            _audioURL = url;
        }
    }
    return _audioURL;
}

- (void)setAudioURL:(NSURL *)audioURL
{
    // don't store temp path so media store can return permanent path
    _audioURL = nil;
    if (audioURL) {
        [[OHMMediaStore sharedStore] setAudioWithURL:audioURL forKey:self.uuid];
    }
    else {
        [[OHMMediaStore sharedStore] deleteAudioForKey:self.uuid];
    }
}

- (UIImage *)imageValue
{
    if (_imageValue == nil) {
        _imageValue = [[OHMMediaStore sharedStore] imageForKey:self.uuid];
    }
    return _imageValue;
}

- (void)setImageValue:(UIImage *)imageValue
{
    _imageValue = imageValue;
    if (imageValue) {
        [[OHMMediaStore sharedStore] setImage:imageValue forKey:self.uuid];
    }
    else {
        [[OHMMediaStore sharedStore] deleteImageForKey:self.uuid];
    }
}

- (NSArray *)valArray
{
    NSMutableArray *valArray = [NSMutableArray arrayWithCapacity:self.selectedChoices.count];
    [self.selectedChoices enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeNumberMultiChoicePrompt) {
            [valArray addObject:[(OHMSurveyPromptChoice *)obj numberValue]];
        }
        else if (self.surveyItem.itemTypeValue == OHMSurveyItemTypeStringMultiChoicePrompt) {
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
        return nil; //@"SKIPPED";
    }
    else if (self.notDisplayedValue) {
        return nil; //@"NOT_DISPLAYED";
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
            case OHMSurveyItemTypeTimestampPrompt:
                return [self.timestampValue ISO8601String];
            case OHMSurveyItemTypeImagePrompt:
            case OHMSurveyItemTypeVideoPrompt:
            case OHMSurveyItemTypeAudioPrompt:
                return self.mediaAttachmentName;
            default:
                return nil;
        }
    }
}

- (void)clearValues
{
    self.stringValue = nil;
    self.numberValue = nil;
    self.imageValue = nil;
    self.videoURL = nil;
    self.audioURL = nil;
    [self.selectedChoicesSet removeAllObjects];
}

@end
