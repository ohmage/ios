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

//- (NSString *)locationText
//{
//    if (self.name != nil) {
//        return self.name;
//    }
//    else {
//        return [NSString stringWithFormat:@"Lat: %f Long: %f", self.latitudeValue, self.longitudeValue];
//    }
//}

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

//- (NSString *)subtitle
//{
//    return self.locationText;
//}

@end
