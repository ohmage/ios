#import "_OHMSurveyItem.h"
#import "OHMSurveyItemTypes.h"

@interface OHMSurveyItem : _OHMSurveyItem

- (void)setValuesFromDefinition:(NSDictionary *)definition;

- (BOOL)hasDefaultResponse;

//+ (instancetype)itemWithDefinition:(NSDictionary *)itemDefinition;

@end
