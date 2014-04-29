//
//  OHMUserInterface.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Ohmage.h"

@interface OHMUserInterface : NSObject

+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryType:(UITableViewCellAccessoryType)accessoryType
                            fromTableView:(UITableView *)tableView;

+ (UILabel *)headerTitleLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)headerDescriptionLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)headerDetailLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (UILabel *)fixedSizeLabelWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font;
+ (UIView *)fixedSizeFramedLabelWithText:(NSString *)text
                                    size:(CGSize)size
                                    font:(UIFont *)font
                               alignment:(NSTextAlignment)textAlignment;

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)selector maxWidth:(CGFloat)maxWidth;

+ (void)applyRoundedBorderToView:(UIView *)view radius:(CGFloat)borderRadius;

+ (NSString *)formattedDate:(NSDate *)date;

@end
