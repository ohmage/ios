#import "_OHMSurveyPromptResponse.h"

@interface OHMSurveyPromptResponse : _OHMSurveyPromptResponse {}

@property (nonatomic, strong) UIImage *imageValue;
@property (nonatomic, copy) NSURL *videoURL;

- (void)initializeDefaultResonse;

- (BOOL)compareToConditionValue:(id)value withComparison:(NSString *)comparison;

@end
