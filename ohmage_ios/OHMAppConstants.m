//
//  OHMAppConstants.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMAppConstants.h"
#import "UIColor+Ohmage.h"

NSString * const kOhmageGoogleClientID = @"48636836762-detevr4602jd0isb7evsrniklh7q9e6m.apps.googleusercontent.com";
NSString * const kOMHServerGoogleClientID = @"48636836762-mulldgpmet2r4s3f16s931ea9crcc64m.apps.googleusercontent.com";
NSString * const kOhmageDSUClientID = @"org.openmhealth.ios.ohmage";
NSString * const kOhmageDSUClientSecret = @"Rtg43jkLD7z76c";

CGFloat const kUIViewVerticalMargin = 15.0;
CGFloat const kUIViewHorizontalMargin = 15.0;
CGFloat const kUIViewSmallTextMargin = 4.0;
CGFloat const kUIViewSmallMargin = 8.0;

CGFloat const kUIButtonDefaultHeight = 44.0;
CGFloat const kUIButtonHorizontalMargin = 14.0;
CGFloat const kUIButtonVerticalMargin = 6.0;
CGFloat const kUITextFieldDefaultHeight = 30.0;

CGFloat const kUICellImageHeight = 100;

UIEdgeInsets const kUIViewDefaultInsets = {kUIViewVerticalMargin, kUIViewHorizontalMargin, kUIViewVerticalMargin, kUIViewHorizontalMargin};

UIEdgeInsets const kUILabelDefaultInsets = {kUIViewSmallTextMargin, kUIViewHorizontalMargin, kUIViewSmallTextMargin, kUIViewHorizontalMargin};
UIEdgeInsets const kUIButtonTitleDefaultInsets = {kUIButtonVerticalMargin, kUIButtonHorizontalMargin, kUIButtonVerticalMargin, kUIButtonHorizontalMargin};
UIEdgeInsets const kUIButtonTitleSmallInsets = {kUIViewSmallTextMargin, kUIViewSmallTextMargin, kUIViewSmallTextMargin, kUIViewSmallTextMargin};

double const kDefaultLocationRadius = 20.0;
double const kMinLocationRadius = 5.0;
double const kMaxLocationRadius = 500.0;

@implementation OHMAppConstants

+ (UIColor *)colorForSurveyIndex:(NSInteger)rowIndex
{
    rowIndex %= 6;
    UIColor *color = nil;
    switch (rowIndex) {
        case 0:
            color = [UIColor colorWithRed:75.0/255.0 green:188.0/255.0 blue:164.0/255.0 alpha:1.0];
            break;
        case 1:
            color = [UIColor colorWithRed:243.0/255.0 green:169.0/255.0 blue:71.0/255.0 alpha:1.0];
            break;
        case 2:
            color = [UIColor colorWithRed:239.0/255.0 green:92.0/255.0 blue:67.0/255.0 alpha:1.0];
            break;
        case 3:
            color = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
            break;
        case 4:
            color = [UIColor colorWithRed:250.0/255.0 green:225.0/255.0 blue:76.0/255.0 alpha:1.0];
            break;
        case 5:
            color = [UIColor colorWithRed:187.0/255.0 green:143.0/255.0 blue:181.0/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    return color;
}

+ (UIColor *)lightColorForSurveyIndex:(NSInteger)rowIndex
{
    return [[self colorForSurveyIndex:rowIndex] lightColor];
}

+ (UIColor *)ohmageColor
{
    return [UIColor colorWithRed:0.0 green:110.0/255.0 blue:194.0/255.0 alpha:1.0];
}

+ (UIColor *)lightOhmageColor
{
    return [[[self ohmageColor] lightColor] lightColor];
}

+ (UIColor *)primaryTextColor
{
    return [UIColor colorWithRed:28.0/255.0 green:39.0/255.0 blue:57.0/255.0 alpha:1.0];
}

+ (UIColor *)headerTitleColor
{
    return [UIColor blackColor];
}

+ (UIColor *)headerDescriptionColor
{
    return [UIColor darkTextColor];
}

+ (UIColor *)headerDetailColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)buttonTextColor
{
    return [UIColor whiteColor];
}

+ (UIFont *)textFont {
    return [UIFont systemFontOfSize:15.0];
}

+ (UIFont *)smallTextFont {
    return [UIFont systemFontOfSize:11.0];
}

+ (UIFont *)boldTextFont {
    return [UIFont boldSystemFontOfSize:15.0];
}

+ (UIFont *)italicTextFont {
    return [UIFont italicSystemFontOfSize:15.0];
}

+ (UIFont *)headerTitleFont
{
    return [UIFont boldSystemFontOfSize:18.0];
}

+ (UIFont *)headerDescriptionFont
{
    return [UIFont systemFontOfSize:16.0];
}

+ (UIFont *)headerDetailFont
{
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)buttonFont
{
    return [UIFont systemFontOfSize:17.0];
}

+ (UIFont *)cellTextFont
{
    return [UIFont systemFontOfSize:17.0];
}

+ (UIFont *)cellDetailTextFont
{
    return [UIFont systemFontOfSize:14.0];
}

+ (UIFont *)cellSubtitleTextFont
{
    return [UIFont systemFontOfSize:13.0];
}

@end
