#import "_OHMReminderLocation.h"
#import <MapKit/MapKit.h>


@interface OHMReminderLocation : _OHMReminderLocation <MKAnnotation>

@property (nonatomic, strong) CLRegion *region;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

- (NSString *)locationText;

@end
