#import "OHMSurvey.h"

@interface OHMSurvey ()

@end

@implementation OHMSurvey

@synthesize surveyUpdatedBlock;
@synthesize colorIndex;

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"surveys/%@/%d", self.ohmID, self.surveyVersionValue];
}

@end