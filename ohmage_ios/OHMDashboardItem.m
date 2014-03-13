//
//  OHMDashboardObject.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMDashboardItem.h"

NSArray *gDashboardObjectsArray;

@implementation OHMDashboardItem

+ (instancetype)DashboardObjectForID:(int)doID
{
    if (doID < eDOCount) {
        return [[OHMDashboardItem AllDashboardObjects] objectAtIndex:doID];
    }
    else {
        return nil;
    }
}

+ (NSArray*)AllDashboardObjects
{
    if (!gDashboardObjectsArray) {
        gDashboardObjectsArray = [NSArray arrayWithObjects:[[OHMDashboardItem alloc]initWithDOID:eDOProjects],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOSurveys],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOResponseHistory],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOUploadQueue],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOProfile],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOMobility],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOStreams],
                                  [[OHMDashboardItem alloc]initWithDOID:eDOHelp],
                                  nil];
    }
    
    return gDashboardObjectsArray;
}

+ (NSString*)DashboardObjectName:(int)doID
{
    switch(doID) {
        case eDOProjects:
            return @"Projects";
        case eDOSurveys:
            return @"Surveys";
        case eDOResponseHistory:
            return @"Response History";
        case eDOUploadQueue:
            return @"Upload Queue";
        case eDOProfile:
            return @"Profile";
        case eDOMobility:
            return @"Mobility";
        case eDOStreams:
            return @"Streams";
        case eDOHelp:
            return @"Help";
        default:
            return nil;
    }
}

+ (UIImage*)DashboardObjectImage:(int)doID
{
    switch(doID) {
        case eDOProjects:
            return [UIImage imageNamed:@"dash_campaigns"];
        case eDOSurveys:
            return [UIImage imageNamed:@"dash_surveys"];
        case eDOResponseHistory:
            return [UIImage imageNamed:@"dash_resphistory"];
        case eDOUploadQueue:
            return [UIImage imageNamed:@"dash_upqueue"];
        case eDOProfile:
            return [UIImage imageNamed:@"dash_profile"];
        case eDOMobility:
            return [UIImage imageNamed:@"dash_mobility"];
        case eDOStreams:
            return [UIImage imageNamed:@"dash_streams"];
        case eDOHelp:
            return [UIImage imageNamed:@"dash_helpblue"];
        default:
            return nil;
    }
}

+ (UIImage*)DashboardObjectPressedImage:(int)doID
{
    switch(doID) {
        case eDOProjects:
            return [UIImage imageNamed:@"dash_campaigns_pressed"];
        case eDOSurveys:
            return [UIImage imageNamed:@"dash_surveys_pressed"];
        case eDOResponseHistory:
            return [UIImage imageNamed:@"dash_resphistory_pressed"];
        case eDOUploadQueue:
            return [UIImage imageNamed:@"dash_upqueue_pressed"];
        case eDOProfile:
            return [UIImage imageNamed:@"dash_profile_pressed"];
        case eDOMobility:
            return [UIImage imageNamed:@"dash_mobility_pressed"];
        case eDOStreams:
            return [UIImage imageNamed:@"dash_streams_pressed"];
        case eDOHelp:
            return [UIImage imageNamed:@"dash_helpblue_pressed"];
        default:
            return nil;
    }
}

- (instancetype)initWithDOID:(DOID)aDOID
{
    self = [super init];
    
    if (self) {
        _doID = aDOID;
        _name = [OHMDashboardItem DashboardObjectName:aDOID];
        _image = [OHMDashboardItem DashboardObjectImage:aDOID];
        _pressedImage = [OHMDashboardItem DashboardObjectPressedImage:aDOID];
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"DOID: %d, name: %@", self.doID, self.name];
}

@end
