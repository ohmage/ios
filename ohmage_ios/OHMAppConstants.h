//
//  OHMAppConstants.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

extern CGFloat const kUIViewVerticalMargin;
extern CGFloat const kUIViewHorizontalMargin;
extern CGFloat const kUIViewSmallTextMargin;
extern CGFloat const kUIViewSmallMargin;
extern UIEdgeInsets const kUIViewDefaultInsets;

extern UIEdgeInsets const kUIButtonTitleDefaultInsets;
extern UIEdgeInsets const kUIButtonTitleSmallInsets;
extern CGFloat const kUIButtonDefaultHeight;
extern CGFloat const kUITextFieldDefaultHeight;

@interface OHMAppConstants : NSObject

+ (UIColor *)colorForRowIndex:(NSInteger)rowIndex;
+ (UIColor *)lightColorForRowIndex:(NSInteger)rowIndex;
+ (UIColor *)ohmageColor;
+ (UIColor *)lightOhmageColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)headerTitleColor;
+ (UIColor *)headerDescriptionColor;
+ (UIColor *)headerDetailColor;
+ (UIColor *)buttonTextColor;


+ (UIFont *)textFont;
+ (UIFont *)smallTextFont;
+ (UIFont *)boldTextFont;
+ (UIFont *)italicTextFont;
+ (UIFont *)headerTitleFont;
+ (UIFont *)headerDescriptionFont;
+ (UIFont *)headerDetailFont;
+ (UIFont *)buttonFont;

@end
