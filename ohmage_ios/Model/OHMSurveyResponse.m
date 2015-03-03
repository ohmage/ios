#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMConditionParserDelegate.h"

#import "OMHDataPoint.h"


@interface OHMSurveyResponse ()

@end


@implementation OHMSurveyResponse

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.uuid = [[[NSUUID alloc] init] UUIDString];
}

- (OHMSurveyPromptResponse *)promptResponseForItemID:(NSString *)itemID
{
    for (OHMSurveyPromptResponse *response in self.promptResponses) {
        if ([response.surveyItem.itemID isEqualToString:itemID]) {
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

- (NSDictionary *)dataPointBody
{
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    
    if (self.locTimestamp != nil) {
        NSMutableDictionary *location = [NSMutableDictionary dictionary];
        location.surveyResponseLatitude = self.locLatitude;
        location.surveyResponseLongitude = self.locLongitude;
        location.surveyResponseLocationAccuracy = self.locAccuracy;
        location.surveyResponseLocationTimestamp = @([self.locTimestamp timeIntervalSince1970]);
        body.surveyResponseMetadataLocation = location;
    }
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [self.promptResponses enumerateObjectsUsingBlock:^(OHMSurveyPromptResponse *promptResponse, NSUInteger idx, BOOL *stop) {
        id val = [promptResponse jsonVal];
        if (val) {
            data[promptResponse.surveyItem.itemID] = (NSArray *)val;
        }
    }];
    
    body.surveyResponseData = data;
    return body;
}

- (NSDictionary *)dataPoint
{
    OMHDataPoint *dataPoint = [OMHDataPoint templateDataPoint];
    dataPoint.header.schemaID = [self schemaID];
    dataPoint.header.acquisitionProvenance = [OHMSurveyResponse acquisitionProvenance];
    dataPoint.header.headerID = self.uuid;
    dataPoint.header.creationDateTime = self.timestamp;
    dataPoint.body = [self dataPointBody];
    return dataPoint;

}

- (NSArray *)mediaAttachments
{
    NSMutableArray *attachments = [NSMutableArray array];
    for (OHMSurveyPromptResponse *promptResponse in self.promptResponses) {
        NSDictionary *attachment = promptResponse.mediaAttachment;
        if (attachment != nil) {
            [attachments addObject:promptResponse.mediaAttachment];
        }
    }
    
    if (attachments.count > 0) return attachments;
    else return nil;
}

- (OMHSchemaID *)schemaID
{
    OMHSchemaID *schemdaID = [[OMHSchemaID alloc] init];
    schemdaID.schemaNamespace = self.survey.schemaNamespace;
    schemdaID.name = self.survey.schemaName;
    schemdaID.version = self.survey.schemaVersion;
    return schemdaID;
}

+ (OMHAcquisitionProvenance *)acquisitionProvenance
{
    static OMHAcquisitionProvenance *sProvenance = nil;
    if (!sProvenance) {
        sProvenance = [[OMHAcquisitionProvenance alloc] init];
        sProvenance.sourceName = @"Ohmage-iOS-1.0";
        sProvenance.modality = OMHAcquisitionProvenanceModalitySelfReported;
    }
    return sProvenance;
}

//- (NSString *)uploadRequestUrlString
//{
//    return [NSString stringWithFormat:@"surveys/%@/%@/data", self.survey.schemaName, self.survey.schemaVersion];
//}
//
//- (NSURL *)tempFileURL
//{
//    NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
//                                        NSUserDomainMask,
//                                        YES);
//    
//    NSString *cacheDirectory = [cacheDirectories firstObject];
//    NSString *filePath = [cacheDirectory stringByAppendingPathComponent:self.uuid];
//    return [NSURL fileURLWithPath:filePath];
//}
//
//- (void)removeTempFile
//{
//    [[NSFileManager defaultManager] removeItemAtURL:[self tempFileURL] error:nil];
//}

- (NSArray *)displayedPromptResponses
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notDisplayed == NO"];
    return [[self.promptResponses filteredOrderedSetUsingPredicate:predicate] array];
}


@end
