//
//  OHMObject.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <CoreData/CoreData.h>

@protocol OHMObjectProtocol <NSObject>

@property (nonatomic, strong) NSString *ohmID;

- (NSString *)definitionRequestUrlString;

@end

@interface OHMObject : NSManagedObject<OHMObjectProtocol>
@end
