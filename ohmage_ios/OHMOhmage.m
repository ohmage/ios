//
//  OHMAccountManager.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/3/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMOhmage.h"

@implementation OHMOhmage

+ (NSString *)accountArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"account.archive"];
}

+ (OHMOhmage*)sharedManager
{
    static OHMOhmage *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // first check for archive
        NSString *path = [self accountArchivePath];
        _sharedManager = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!_sharedManager) {
            _sharedManager = [[self alloc] initPrivate];
        }
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMAccountManager sharedManager]"
                                 userInfo:nil];
    return nil;
}

// Secret designated initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}



@end
