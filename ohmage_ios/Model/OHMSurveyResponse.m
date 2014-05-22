#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMConditionParserDelegate.h"


@interface OHMSurveyResponse ()

@end


@implementation OHMSurveyResponse

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.ohmID = key;
}

- (OHMSurveyPromptResponse *)promptResponseForItemID:(NSString *)itemID
{
    for (OHMSurveyPromptResponse *response in self.promptResponses) {
        if ([response.surveyItem.ohmID isEqualToString:itemID]) {
            return response;
        }
    }
    return nil;
}

- (BOOL)shouldShowItemAtIndex:(NSInteger)itemIndex
{
    if (itemIndex >= [self.survey.surveyItems count]) return NO;
    
    OHMSurveyItem *item = self.survey.surveyItems[itemIndex];
    NSString *condition = item.condition;
    
    if (condition == nil) return YES;
    
    OHMConditionParserDelegate *conditionDelegate = [[OHMConditionParserDelegate alloc] initWithSurveyResponse:self];
    
    return [conditionDelegate evaluateConditionString:condition];
}

- (NSDictionary *)JSON
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    metadata.surveyResponseID = self.ohmID;
    metadata.surveyResponseTimestamp = self.timestamp.ISO8601String;
    
    if (self.locTimestamp != nil) {
        NSMutableDictionary *location = [NSMutableDictionary dictionary];
        location.surveyResponseLatitude = self.locLatitude;
        location.surveyResponseLongitude = self.locLongitude;
        location.surveyResponseLocationAccuracy = self.locAccuracy;
        location.surveyResponseLocationTimestamp = @([self.locTimestamp timeIntervalSince1970]);
        metadata.surveyResponseMetadataLocation = location;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [self.promptResponses enumerateObjectsUsingBlock:^(OHMSurveyPromptResponse *promptResponse, NSUInteger idx, BOOL *stop) {
        id val = [promptResponse jsonVal];
        if (val) {
            data[promptResponse.surveyItem.ohmID] = (NSArray *)val;
        }
    }];
    
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    json.surveyResponseMetadata = metadata;
    json.surveyResponseData = data;
    return json;
}

- (NSString *)uploadRequestUrlString
{
    return [NSString stringWithFormat:@"surveys/%@/%d/data", self.survey.ohmID, self.survey.surveyVersionValue];
}

- (NSURL *)tempFileURL
{
    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                        NSUserDomainMask,
                                        YES);
    
    NSString *cacheDirectory = [cacheDirectories firstObject];
    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:self.ohmID];
    return [NSURL fileURLWithPath:filePath];
}

- (void)removeTempFile
{
    [[NSFileManager defaultManager] removeItemAtURL:[self tempFileURL] error:nil];
}


@end
