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

- (NSString *)description
{
    return [NSString stringWithFormat:@"Survey name: %@, id: %@, version %d", self.surveyName, self.ohmID, self.surveyVersionValue];
}

@end