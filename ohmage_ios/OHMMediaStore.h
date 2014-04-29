//
//  OHMImageStore.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMMediaStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

- (void)setVideoWithURL:(NSURL *)tempVideoURL forKey:(NSString *)key;
- (NSURL *)videoURLForKey:(NSString *)key;
- (void)deleteVideoForKey:(NSString *)key;

@end
