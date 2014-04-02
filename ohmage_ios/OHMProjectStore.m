//
//  OHMProjectStore.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMProjectStore.h"
#import "OHMProject.h"

@interface OHMProjectStore ()

@property (nonatomic) NSMutableArray *privateProjects;

@end


@implementation OHMProjectStore

+ (instancetype)sharedStore
{
    static OHMProjectStore *sharedStore = nil;
    
    // thread-safe singleton
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

// If a programmer calls [[OHMProjectStore alloc] init], let him
// know the error of his ways
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[OHMProjectStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateProjects = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allProjects
{
    return self.privateProjects;
}

- (OHMProject *)createProject
{
    OHMProject *project = [OHMProject sampleProject];
    
    [self.privateProjects addObject:project];
    
    return project;
}

- (void)removeProject:(OHMProject *)project
{
    [self.privateProjects removeObjectIdenticalTo:project];
}

- (void)moveProjectAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    OHMProject *Project = self.privateProjects[fromIndex];
    
    // Remove Project from array
    [self.privateProjects removeObjectAtIndex:fromIndex];
    
    // Insert Project in array at new location
    [self.privateProjects insertObject:Project atIndex:toIndex];
}



@end
