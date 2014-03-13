//
//  OHMProject.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMProject : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *urn;
@property (nonatomic, copy) NSString *privacy;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, readonly) NSArray *responses;
@property (nonatomic, readonly) NSArray *reminders;

+ (OHMProject*)sampleProject;

@end
