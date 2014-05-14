#import "OHMReminderLocation.h"


@interface OHMReminderLocation ()

// Private interface goes here.

@end


@implementation OHMReminderLocation

@synthesize region;

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

- (NSString *)locationText
{
    if (self.name != nil) {
        return self.name;
    }
    else {
        return [NSString stringWithFormat:@"Lat: %f Long: %f", self.latitudeValue, self.longitudeValue];
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
}

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return self.locationText;
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
