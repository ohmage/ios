//
//  OHMProject.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMProject.h"

@implementation OHMProject

+ (OHMProject*)sampleProject
{
    static OHMProject *sampleProject = nil;
    
    if (!sampleProject) {
        sampleProject = [[self alloc] init];
        sampleProject.name = @"iOS App Test Campaign";
        sampleProject.urn = @"urn:campaign:cforkish:ios_test";
        sampleProject.privacy = @"private";
        sampleProject.status = @"participating";
        
    }
    
    return sampleProject;
}

@end
