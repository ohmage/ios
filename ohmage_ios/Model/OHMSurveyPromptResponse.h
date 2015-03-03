#import "_OHMSurveyPromptResponse.h"

@interface OHMSurveyPromptResponse : _OHMSurveyPromptResponse {}

@property (nonatomic, strong) UIImage *imageValue;
@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic, copy) NSURL *audioURL;

- (void)initializeDefaultResonse;
- (id)jsonVal;

- (BOOL)hasValue;
//- (BOOL)hasMediaAttachment;
- (NSDictionary *)mediaAttachment;
//- (NSURL *)mediaAttachmentURL;
//- (NSString *)mediaAttachmentName;
//- (NSString *)mimeType;

- (void)clearValues;

@end
