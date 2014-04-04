//
//  OHMOhmage.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/3/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMOhmlet;
@protocol OHMOhmageDelegate;

@interface OHMOhmage : NSObject

@property (nonatomic, weak) id<OHMOhmageDelegate> delegate;
@property (nonatomic, strong) OHMOhmlet *ohmlet;

+ (OHMOhmage*)sharedOhmage;

- (void)login;

@end

@protocol OHMOhmageDelegate <NSObject>
@optional
- (void)OHMOhmage:(OHMOhmage *)ohmage didRefreshSurveys:(NSArray *)surveys;
@end

