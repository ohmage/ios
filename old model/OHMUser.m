//
//  OHMUser.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMUser.h"
#import "OHMHTTPClient.h"
#import "OHMOhmlet.h"

@interface OHMUser () <OHMHTTPClientDelegate>

@end

@implementation OHMUser

// Secret designated initializer
- (instancetype)initWithEmail:(NSString *)email password:(NSString *)password
{
    self = [super init];
    
    if (self) {
        self.email = email;
        self.password = password;
    }
    
    return self;
}

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"people/%@/current", self.ohmId];
}

- (void)updateFromServer
{
//    __weak OHMUser *weakSelf = self;
//    
//    [self.httpClient getRequest:[self definitionRequestUrlString]
//                 withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
//        
//        if (error) {
//            NSLog(@"Update user info Error");
//        }
//        else {
//            NSLog(@"update user info Success");
//            
//            weakSelf.fullName = [response userFullName];
//            NSDictionary *ohmletDef = [[response ohmlets] firstObject];
//            NSString *ohmletId = [ohmletDef ohmletId];
//            
//            if ([ohmletId isEqualToString:weakSelf.ohmlet.ohmId]) {
//                [weakSelf.ohmlet updateFromServer];
//            }
//            else {
//                weakSelf.ohmlet = [OHMOhmlet loadFromServerWithId:ohmletId];
//            }
//            
//            if ([weakSelf.delegate respondsToSelector:@selector(OHMUser:didRefreshOhmlet:)]) {
//                [weakSelf.delegate OHMUser:weakSelf didRefreshOhmlet:weakSelf.ohmlet];
//            }
//        }
//    }];
}

@end
