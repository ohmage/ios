//
//  OHMProjectStore.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OHMProject;

@interface OHMProjectStore : NSObject
+ (instancetype)sharedStore;

@property (nonatomic, readonly) NSArray *allProjects;

- (OHMProject *)createProject;
- (void)removeProject:(OHMProject *)project;
- (void)moveProjectAtIndex:(NSUInteger)fromIndex
                   toIndex:(NSUInteger)toIndex;

@end
