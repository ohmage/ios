//
//  OHMReminderMapViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseViewController.h"

@class OHMReminderLocation;
@class MKMapItem;

@interface OHMLocationMapViewController : OHMBaseViewController

- (instancetype)initWithLocation:(OHMReminderLocation *)location;
- (instancetype)initWithMapItem:(MKMapItem *)mapItem;

@end
