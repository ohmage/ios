#import "OHMOhmlet.h"


@interface OHMOhmlet ()

// Private interface goes here.

@end


@implementation OHMOhmlet

@synthesize ohmletUpdatedBlock;

- (NSString *)definitionRequestUrlString
{
    return [@"ohmlets/" stringByAppendingString:self.ohmID];
}

@end
