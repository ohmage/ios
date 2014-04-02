//
//  OHMOhmlet.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMOhmlet : OHMObject

@property (nonatomic, copy) NSString *ohmletName;
@property (nonatomic, copy) NSString *ohmletDescription;

+ (instancetype)loadFromServerWithId:(NSString *)ohmletId;


@end
