#import "OHMSurvey.h"

@interface OHMSurvey ()

@end

@implementation OHMSurvey

@synthesize surveyUpdatedBlock;

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"surveys/%@/%d", self.ohmID, self.surveyVersionValue];
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"Survey name: %@, id: %@, version %d", self.surveyName, self.ohmID, self.surveyVersionValue];
//}

@end