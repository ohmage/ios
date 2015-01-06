#import "_OHMSurveyResponse.h"

@interface OHMSurveyResponse : _OHMSurveyResponse {}

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex;
- (OHMSurveyPromptResponse *)promptResponseForItemID:(NSString *)itemID;

- (NSDictionary *)dataPoint;
- (NSString *)uploadRequestUrlString;
- (NSURL *)tempFileURL;
- (void)removeTempFile;

- (NSArray *)displayedPromptResponses;

@end
