#import "OHMUser.h"

@interface OHMUser ()

// Private interface goes here.

@end


@implementation OHMUser

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"people/%@/current", self.ohmID];
}

@end
