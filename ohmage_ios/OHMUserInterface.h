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

+ (CGSize)sizeForText:(NSString *)text withWidth:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryType:(UITableViewCellAccessoryType)accessoryType
                            fromTableView:(UITableView *)tableView;
+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryWidth:(CGFloat)accessoryWidth
                            fromTableView:(UITableView *)tableView;
+ (CGFloat)heightForSwitchCellWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                          fromTableView:(UITableView *)tableView;
+ (CGFloat)heightForImageCellWithText:(NSString *)text fromTableView:(UITableView *)tableView;
+ (UIView *)tableFooterViewWithButton:(NSString *)title fromTableView:(UITableView *)tableView setupBlock:(void (^)(UIButton *))buttonBlock;
+ (UITableViewCell *)cellWithDefaultStyleFromTableView:(UITableView *)tableView;
+ (UITableViewCell *)cellWithDetailStyleFromTableView:(UITableView *)tableView;
+ (UITableViewCell *)cellWithSubtitleStyleFromTableView:(UITableView *)tableView;
+ (UITableViewCell *)cellWithImage:(UIImage *)image text:(NSString *)text fromTableView:(UITableView *)tableView;
+ (UITableViewCell *)cellWithSwitchFromTableView:(UITableView *)tableView setupBlock:(void (^)(UISwitch *sw))swBlock;
+ (UITableViewCell *)cellWithTimePickerFromTableView:(UITableView *)tableView setupBlock:(void (^)(UIDatePicker *dp))dpBlock;
+ (UITableViewCell *)cellWithSegmentedControlFromTableView:(UITableView *)tableView setupBlock:(void (^)(UISegmentedControl *sc))scBlock;

+ (UILabel *)headerTitleLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)headerDescriptionLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)headerDetailLabelWithText:(NSString *)text width:(CGFloat)width;
+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font fixedWidth:(BOOL)fixedWidth;
+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (UILabel *)fixedSizeLabelWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font;
+ (UIView *)fixedSizeFramedLabelWithText:(NSString *)text
                                    size:(CGSize)size
                                    font:(UIFont *)font
                               alignment:(NSTextAlignment)textAlignment;
+ (UIView *)textFieldWithLabelText:(NSString *)text setupBlock:(void (^)(UITextField *tf))tfBlock;

+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color  target:(id)target action:(SEL)selector maxWidth:(CGFloat)maxWidth;
+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)selector fixedWidth:(CGFloat)fixedWidth;
+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color  target:(id)target action:(SEL)selector size:(CGSize)size;

+ (void)applyRoundedBorderToView:(UIView *)view radius:(CGFloat)borderRadius;

+ (NSString *)formattedDate:(NSDate *)date;
+ (NSString *)formattedTime:(NSDate *)time;

@end
