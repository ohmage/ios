//
//  OHMObject.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMObject.h"

@implementation OHMObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.httpClient = [OHMHTTPClient sharedClient];
    }
    return self;
}

- (void)updateFromServer {}

- (NSString*)definitionRequestUrlString { return nil; }

@end
