//
//  OHMDashboardObject.h
//  ohmage_ios
//
//  Created by Charles Forkish on 3/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef int DOID;

enum EDashboardObjectIDs {
    eDOProjects = 0,
    eDOSurveys,
    eDOResponseHistory,
    eDOUploadQueue,
    eDOProfile,
    eDOMobility,
    eDOStreams,
    eDOHelp,
    eDOCount
};

@interface OHMDashboardItem : NSObject

@property(nonatomic) DOID doID;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *pressedImage;

+ (instancetype)DashboardObjectForID:(DOID)doID;
+ (NSArray*)AllDashboardObjects;

+ (NSString*)DashboardObjectName:(DOID)doID;
+ (UIImage*)DashboardObjectImage:(DOID)doID;
+ (UIImage*)DashboardObjectPressedImage:(DOID)doID;

- (instancetype)initWithDOID:(DOID)aDOID;

@end
