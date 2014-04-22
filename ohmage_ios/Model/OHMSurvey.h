#import "_OHMSurvey.h"

@class OHMOhmlet;
@protocol OHMSurveyDelegate;

@interface OHMSurvey : _OHMSurvey

@property (nonatomic, weak) id<OHMSurveyDelegate> delegate;

@property (nonatomic, copy) void (^surveyUpdatedBlock)(void);

@property (nonatomic) BOOL isLoaded;

+ (instancetype)loadFromServerWithDefinition:(NSDictionary *)surveyDefinition;

@end


@protocol OHMSurveyDelegate <NSObject>
- (void)OHMSurveDidUpdate:(OHMSurvey *)survey;
@end