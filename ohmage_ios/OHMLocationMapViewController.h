//
//  OHMReminderMapViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseViewController.h"

@class OHMReminderLocation;

@interface OHMLocationMapViewController : OHMBaseViewController

@property (nonatomic) BOOL isCurrentLocation;

- (instancetype)initWithLocation:(OHMReminderLocation *)location;

@end
