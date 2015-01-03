//
//  OHMAppConstants.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kOhmageGoogleClientID;
extern NSString * const kOMHServerGoogleClientID;
extern NSString * const kOhmageDSUClientID;
extern NSString * const kOhmageDSUClientSecret;

extern CGFloat const kUIViewVerticalMargin;
extern CGFloat const kUIViewHorizontalMargin;
extern CGFloat const kUIViewSmallTextMargin;
extern CGFloat const kUIViewSmallMargin;
extern UIEdgeInsets const kUIViewDefaultInsets;

extern UIEdgeInsets const kUILabelDefaultInsets;
extern UIEdgeInsets const kUIButtonTitleDefaultInsets;
extern UIEdgeInsets const kUIButtonTitleSmallInsets;
extern CGFloat const kUIButtonDefaultHeight;
extern CGFloat const kUITextFieldDefaultHeight;

extern CGFloat const kUICellImageHeight;

extern double const kDefaultLocationRadius;
extern double const kMinLocationRadius;
extern double const kMaxLocationRadius;

@interface OHMAppConstants : NSObject

// colors
+ (UIColor *)colorForSurveyIndex:(NSInteger)rowIndex;
+ (UIColor *)lightColorForSurveyIndex:(NSInteger)rowIndex;
+ (UIColor *)ohmageColor;
+ (UIColor *)lightOhmageColor;
+ (UIColor *)primaryTextColor;
+ (UIColor *)headerTitleColor;
+ (UIColor *)headerDescriptionColor;
+ (UIColor *)headerDetailColor;
+ (UIColor *)buttonTextColor;

//fonts
+ (UIFont *)textFont;
+ (UIFont *)smallTextFont;
+ (UIFont *)boldTextFont;
+ (UIFont *)italicTextFont;
+ (UIFont *)headerTitleFont;
+ (UIFont *)headerDescriptionFont;
+ (UIFont *)headerDetailFont;
+ (UIFont *)buttonFont;
+ (UIFont *)cellTextFont;
+ (UIFont *)cellDetailTextFont;
+ (UIFont *)cellSubtitleTextFont;

@end
