#import "OHMSurvey.h"

@interface OHMSurvey ()

@end

@implementation OHMSurvey

@synthesize surveyUpdatedBlock;

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"surveys/%@/%d", self.ohmID, self.surveyVersionValue];
}

@end