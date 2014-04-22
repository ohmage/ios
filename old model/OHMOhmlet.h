//
//  OHMOhmlet.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OHMOhmletDelegate;

@interface OHMOhmlet : OHMObject

@property (nonatomic, weak) id<OHMOhmletDelegate>delegate;

@property (nonatomic, copy) NSString *ohmletName;
@property (nonatomic, copy) NSString *ohmletDescription;

+ (instancetype)loadFromServerWithId:(NSString *)ohmletId;

- (NSArray *)allSurveys;
- (NSInteger)surveyCount;

@end


@protocol OHMOhmletDelegate <NSObject>
@optional
- (void)OHMOhmletDidRefreshSurveys:(OHMOhmlet*)ohmlet;
@end
