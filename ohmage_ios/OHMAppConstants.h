//
//  OHMAppConstants.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMAppConstants : NSObject

+ (UIColor *)colorForRowIndex:(NSInteger)rowIndex;
+ (UIColor *)lightColorForRowIndex:(NSInteger)rowIndex;
+ (UIColor *)ohmageColor;
+ (UIColor *)lightOhmageColor;


+ (UIFont *)textFont;
+ (UIFont *)smallTextFont;
+ (UIFont *)boldTextFont;
+ (UIFont *)italicTextFont;

@end
