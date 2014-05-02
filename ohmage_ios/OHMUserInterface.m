//
//  OHMUserInterface.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMUserInterface.h"

@implementation OHMUserInterface


+ (CGSize)ceilSize:(CGSize)size
{
    size.width = ceilf(size.width);
    size.height = ceilf(size.height);
    return size;
}

+ (CGFloat)cellContentWidthForAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    switch (accessoryType) {
        case UITableViewCellAccessoryNone:
            return 320.0;
            break;
        case UITableViewCellAccessoryDisclosureIndicator:
            return 287.0;
            break;
        case UITableViewCellAccessoryDetailDisclosureButton:
            return 253.0;
            break;
        case UITableViewCellAccessoryDetailButton:
            return 273.0;
            break;
        default:
            return 320.0;
            break;
    }
}

+ (CGSize)sizeForText:(NSString *)text withWidth:(CGFloat)width font:(UIFont *)font
{
    if (text == nil) return CGSizeZero;
    
    CGSize constraintSize = CGSizeMake(width, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil];
//    rect.size.width = width;
    return [self ceilSize:rect.size];
}

+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width font:(UIFont *)font
{
    return [self sizeForText:text withWidth:width font:font].height;
}

+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryType:(UITableViewCellAccessoryType)accessoryType
                            fromTableView:(UITableView *)tableView
{
    static UIFont *titleFont = nil;
    static UIFont *subtitleFont = nil;
    if (titleFont == nil) {
        UITableViewCell *dummyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        titleFont = dummyCell.textLabel.font;
        subtitleFont = dummyCell.detailTextLabel.font;
    }
    
    CGFloat width = [self cellContentWidthForAccessoryType:accessoryType] - kUIViewHorizontalMargin;
    CGFloat titleHeight = [self heightForText:title withWidth:width font:titleFont];
    CGFloat subtitleHeight = [self heightForText:subtitle withWidth:width font:subtitleFont];
    
    return MAX(titleHeight + subtitleHeight + kUIViewVerticalMargin, tableView.rowHeight);
}

+ (UITableViewCell *)cellWithDefaultStyleFromTableView:(UITableView *)tableView
{
    static NSString *sCellIdentifier = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithDetailStyleFromTableView:(UITableView *)tableView {
    static NSString *sCellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithSwitchFromTableView:(UITableView *)tableView setupBlock:(void (^)(UISwitch *))swBlock
{
    UITableViewCell *cell = [self cellWithDefaultStyleFromTableView:tableView];
    UISwitch *sw = [[UISwitch alloc] init];
    cell.accessoryView = sw;
    if (swBlock) {
        swBlock(sw);
    }
    return cell;
}

+ (UITableViewCell *)cellWithTimePickerFromTableView:(UITableView *)tableView setupBlock:(void (^)(UIDatePicker *dp))dpBlock
{
    static NSString *sCellIdentifier = @"PickerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [cell.contentView addSubview:datePicker];
        if (dpBlock) {
            dpBlock(datePicker);
        }
    }
    
    return cell;
}


+ (UILabel *)headerTitleLabelWithText:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerTitleFont]];
    label.textColor = [OHMAppConstants headerTitleColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)headerDescriptionLabelWithText:(NSString *)text width:(CGFloat)width
{
    
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerDescriptionFont]];
    label.textColor = [OHMAppConstants headerDescriptionColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)headerDetailLabelWithText:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerDetailFont]];
    label.textColor = [OHMAppConstants headerDetailColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)baseLabelWithText:(NSString *)text font:(UIFont *)font size:(CGSize)size
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = font;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    [label constrainSize:size];
    
    return label;
}

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    CGSize size = [self sizeForText:text withWidth:width font:font];
    return [self baseLabelWithText:text font:font size:size];
}

+ (UILabel *)fixedSizeLabelWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font
{
    UILabel *label = [self baseLabelWithText:text font:font size:size];
    label.adjustsFontSizeToFitWidth = YES;
    label.minimumScaleFactor = 0.5;
    
    return label;
}


+ (UIView *)fixedSizeFramedLabelWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font alignment:(NSTextAlignment)textAlignment
{
    UIView *frameView = [[UIView alloc] init];
    [frameView constrainSize:size];
    [self applyRoundedBorderToView:frameView radius:6.0];
    
    CGSize labelSize = CGSizeMake(size.width - kUIViewSmallTextMargin * 2, size.height - kUIViewSmallTextMargin * 2);
    UILabel *label = [self fixedSizeLabelWithText:text size:labelSize font:font];
    label.textAlignment = textAlignment;
    
    [frameView addSubview:label];
    [label centerInView:frameView];
    
    return frameView;
}

+ (UIView *)textFieldWithLabelText:(NSString *)text setupBlock:(void (^)(UITextField *tf))tfBlock
{
    UIView *contentView = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [OHMAppConstants boldTextFont];
    [contentView addSubview:label];
    [label constrainToTopInParentWithMargin:0];
    [contentView constrainChild:label toHorizontalInsets:UIEdgeInsetsZero];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [contentView addSubview:textField];
    [textField constrainHeight:kUITextFieldDefaultHeight];
    [textField positionBelowElement:label margin:kUIViewSmallTextMargin];
    [contentView constrainChild:textField toHorizontalInsets:UIEdgeInsetsZero];
    [textField constrainToBottomInParentWithMargin:0];
    
    if (tfBlock) {
        tfBlock(textField);
    }
    
    return contentView;
}

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)selector maxWidth:(CGFloat)maxWidth
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    UIEdgeInsets insets = kUIButtonTitleDefaultInsets;
    button.titleEdgeInsets = insets;
    button.titleLabel.numberOfLines = 0;
    CGFloat titleWidth = maxWidth - (insets.left + insets.right);
    CGSize titleSize = [self sizeForText:title withWidth:titleWidth font:button.titleLabel.font];
    CGSize buttonSize = CGSizeMake(titleSize.width + (insets.left + insets.right), titleSize.height + (insets.top + insets.bottom));
    [button constrainSize:buttonSize];
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title target:(id)target action:(SEL)selector size:(CGSize)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.titleEdgeInsets = kUIButtonTitleDefaultInsets;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.5;
//    button.titleLabel.numberOfLines = 0;
    [button constrainSize:size];
    return button;
}

+ (void)applyRoundedBorderToView:(UIView *)view radius:(CGFloat)borderRadius
{
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.borderColor = [UIColor clearColor].CGColor;// [UIColor colorWithWhite:0.72 alpha:1.0].CGColor;
//    view.layer.borderWidth = 3.0f;
    view.layer.cornerRadius = borderRadius;
    // This has to be 'NO' for shadows to work.
    view.layer.masksToBounds = YES;
//    view.layer.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    view.layer.shadowRadius = 0;
//    view.layer.shadowOpacity = 1.0;
}

+ (NSString *)formattedDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMM d h:m" options:0
                                                                  locale:[NSLocale currentLocale]];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
//        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)formattedTime:(NSDate *)time
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
//        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMM d h:m" options:0
//                                                                  locale:[NSLocale currentLocale]];
        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:formatString];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return [dateFormatter stringFromDate:time];
}

@end
