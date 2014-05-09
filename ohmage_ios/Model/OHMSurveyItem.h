#import "_OHMSurveyItem.h"
#import "OHMSurveyItemTypes.h"

@interface OHMSurveyItem : _OHMSurveyItem

// maxDuration is in millisecond, NSTimeInterval is in seconds
@property (nonatomic, readonly) NSTimeInterval maxDurationTimeInterval;

- (void)setValuesFromDefinition:(NSDictionary *)definition;

- (BOOL)hasDefaultResponse;


//+ (instancetype)itemWithDefinition:(NSDictionary *)itemDefinition;

@end
