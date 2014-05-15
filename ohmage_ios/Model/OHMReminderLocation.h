#import "_OHMReminderLocation.h"
#import <MapKit/MapKit.h>


@interface OHMReminderLocation : _OHMReminderLocation <MKAnnotation>

@property (nonatomic, readonly) CLRegion *region;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
//@property (nonatomic, readonly, copy) NSString *subtitle;

//- (NSString *)locationText;
//- (void)updateWithPlacemark:(CLPlacemark *)placemark;

@end
