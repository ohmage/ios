#import "OHMReminderLocation.h"


@interface OHMReminderLocation ()

// Private interface goes here.

@end


@implementation OHMReminderLocation

@synthesize region=_region;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    // Create an NSUUID object - and get its string representation
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.ohmID = key;

    self.radiusValue = kDefaultLocationRadius;
    self.name = @"New Location";
}

- (void)updateWithPlacemark:(CLPlacemark *)placemark
{
    NSLog(@"place name: %@, %@", placemark.name, placemark);
    self.coordinate = placemark.location.coordinate;
    self.name = placemark.name;
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
        _region = [[CLCircularRegion alloc] initWithCenter:self.coordinate radius:self.radiusValue identifier:self.ohmID];
    }
    return _region;
}

- (NSString *)title
{
    return self.name;
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
