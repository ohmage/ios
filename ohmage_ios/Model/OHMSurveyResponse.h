#import "_OHMSurveyResponse.h"

@interface OHMSurveyResponse : _OHMSurveyResponse {}

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex;
- (OHMSurveyPromptResponse *)promptResponseForItemID:(NSString *)itemID;

- (NSDictionary *)JSON;

@end
