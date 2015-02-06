//
//  OMHApplication.m
//  PAM
//
//  Created by Charles Forkish on 2/6/15.
//  Copyright (c) 2015 Charlie Forkish. All rights reserved.
//

#import "OMHApplication.h"

@implementation OMHApplication

- (BOOL)openURL:(NSURL*)url {
    
    if ([[url absoluteString] hasPrefix:@"googlechrome-x-callback:"]) {
        
        return NO;
        
    } else if ([[url absoluteString] hasPrefix:@"https://accounts.google.com/o/oauth2/auth"]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationOpenGoogleAuthNotification object:url];
        return NO;
        
    }
    
    return [super openURL:url];
}

@end
