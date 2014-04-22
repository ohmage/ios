#import "_OHMOhmlet.h"

@protocol OHMOhmletDelegate;

@interface OHMOhmlet : _OHMOhmlet

@property (nonatomic, weak) id<OHMOhmletDelegate>delegate;

+ (instancetype)loadFromServerWithId:(NSString *)ohmletId;

- (NSArray *)allSurveys;
- (NSInteger)surveyCount;

@end


@protocol OHMOhmletDelegate <NSObject>
@optional
- (void)OHMOhmletDidRefreshSurveys:(OHMOhmlet*)ohmlet;
@end
