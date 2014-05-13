#import "_OHMReminderLocation.h"
#import <MapKit/MapKit.h>


@interface OHMReminderLocation : _OHMReminderLocation <MKAnnotation, MKOverlay>

- (NSString *)locationText;

@end
