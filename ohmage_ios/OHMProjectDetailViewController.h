//
//  OHMProjectDetailViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMDetailViewController.h"

@class OHMProject;

@interface OHMProjectDetailViewController : OHMDetailViewController

@property (nonatomic, strong) OHMProject *project;

- (instancetype)initWithProject:(OHMProject*)project;

@end
