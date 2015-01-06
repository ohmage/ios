#import "OHMReminderLocation.h"


@interface OHMReminderLocation ()

// Private interface goes here.

@end


@implementation OHMReminderLocation

@synthesize region=_region;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    self.uuid = [[[NSUUID alloc] init] UUIDString];

    self.radiusValue = kDefaultLocationRadius;
    self.name = @"New Location";
}

- (void)updateWithPlacemark:(CLPlacemark *)placemark
{
    
    NSString *streetAddress = nil;
    if (placemark.subThoroughfare.length > 0 && placemark.thoroughfare.length > 0) {
        streetAddress = [NSString stringWithFormat:@"%@ %@", placemark.subThoroughfare, placemark.thoroughfare];
    }
    else if (placemark.subThoroughfare.length > 0) {
        streetAddress = placemark.subThoroughfare;
    }
    else {
        streetAddress = placemark.thoroughfare;
    }
    
    self.streetAddress = streetAddress;
    if (!self.hasCustomNameValue) {
        self.name = placemark.name;
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latitudeValue = newCoordinate.latitude;
    self.longitudeValue = newCoordinate.longitude;
    _region = nil;
}

- (void)setRadiusValue:(float)value_
{
    self.radius = @(value_);
    _region = nil;
}

- (CLRegion *)region
{
    if (_region == nil) {
        _region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:self.radiusValue identifier:self.uuid];
    }
    return _region;
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.streetAddress;
}

- (MKMapRect)boundingMapRect
{
    float metersPerDegreeLat = 111111.0f;
    float radiusMeters = self.radiusValue;
    CLLocationDegrees delta = radiusMeters / metersPerDegreeLat;
    CLLocationDegrees originLatitude = self.coordinate.latitude - delta;
    CLLocationDegrees originLongitude = self.coordinate.longitude - delta;
    
    CLLocationCoordinate2D newOrigin = CLLocationCoordinate2DMake(originLatitude, originLongitude);
    
    MKMapPoint originMapPoint = MKMapPointForCoordinate(newOrigin);
    
    double mapPoints = MKMapPointsPerMeterAtLatitude(self.coordinate.latitude) * radiusMeters;
    
    MKMapRect boundingRect = MKMapRectMake(originMapPoint.x, originMapPoint.y, mapPoints, mapPoints);
    
    return boundingRect;
}

@end
