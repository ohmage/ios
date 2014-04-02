//
//  OHMObject.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMHTTPClient.h"

@interface OHMObject : NSObject

@property (nonatomic, copy) NSString *ohmId;
@property (nonatomic, strong) OHMHTTPClient *httpClient;

- (void)updateFromServer;
- (NSString *)definitionRequestUrlString;

@end
