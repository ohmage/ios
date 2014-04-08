//
//  OHMUser.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMUser : OHMObject

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *fullName;

- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password;

@end