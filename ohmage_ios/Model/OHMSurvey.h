#import "_OHMSurvey.h"

@interface OHMSurvey : _OHMSurvey

@property (nonatomic) NSInteger colorIndex;
@property (nonatomic, copy) void (^surveyUpdatedBlock)(void);

@end