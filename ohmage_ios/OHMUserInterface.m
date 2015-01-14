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

+ (CGFloat)widthForAccessoryOfType:(UITableViewCellAccessoryType)accessoryType
{
    switch (accessoryType) {
        case UITableViewCellAccessoryNone:
            return kUIViewHorizontalMargin;
            break;
        case UITableViewCellAccessoryDisclosureIndicator:
            return 33.0;
            break;
        case UITableViewCellAccessoryDetailDisclosureButton:
            return 67.0;
            break;
        case UITableViewCellAccessoryDetailButton:
            return 47.0;
            break;
        default:
            return 0.0;
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
    
    return [self ceilSize:rect.size];
}

+ (CGFloat)heightForText:(NSString *)text withWidth:(CGFloat)width font:(UIFont *)font
{
    return [self sizeForText:text withWidth:width font:font].height;
}

+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                           accessoryWidth:(CGFloat)accessoryWidth
                            fromTableView:(UITableView *)tableView{
    CGFloat width = tableView.bounds.size.width - 2 * kUIViewSmallMargin - accessoryWidth;
    CGFloat titleHeight = [self heightForText:title withWidth:width font:[OHMAppConstants cellTextFont]];
    CGFloat subtitleHeight = [self heightForText:subtitle withWidth:width font:[OHMAppConstants cellSubtitleTextFont]];
    
    return MAX(titleHeight + subtitleHeight + 2 * kUIViewSmallMargin + kUIViewSmallTextMargin, tableView.rowHeight);
}

+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryType:(UITableViewCellAccessoryType)accessoryType
                            fromTableView:(UITableView *)tableView
{
    return [self heightForSubtitleCellWithTitle:title
                                       subtitle:subtitle
                                 accessoryWidth:[self widthForAccessoryOfType:accessoryType]
                                  fromTableView:tableView];
}

+ (CGFloat)heightForSwitchCellWithTitle:(NSString *)title
                               subtitle:(NSString *)subtitle
                          fromTableView:(UITableView *)tableView
{
    static CGFloat switchWidth = 0;
    if (switchWidth == 0) {
        UISwitch *aSwitch = [[UISwitch alloc] init];
        switchWidth = aSwitch.frame.size.width;
    }
    
    return [self heightForSubtitleCellWithTitle:title
                                       subtitle:subtitle
                                 accessoryWidth:switchWidth
                                  fromTableView:tableView];
}

+ (CGFloat)heightForImageCellWithText:(NSString *)text fromTableView:(UITableView *)tableView
{
    UIEdgeInsets insets = kUILabelDefaultInsets;
    CGFloat labelWidth = tableView.frame.size.width - (insets.left + insets.right);
    CGFloat labelHeight = [self heightForText:text withWidth:labelWidth font:[OHMAppConstants cellTextFont]];
    return labelHeight + insets.top + insets.bottom + kUICellImageHeight + kUIViewSmallMargin;
}

+ (UITableViewCell *)cellWithDefaultStyleFromTableView:(UITableView *)tableView
{
    static NSString *sCellIdentifier = @"DefaultCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [OHMAppConstants cellTextFont];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithDetailStyleFromTableView:(UITableView *)tableView
{
    static NSString *sCellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [OHMAppConstants cellTextFont];
        cell.detailTextLabel.font = [OHMAppConstants cellDetailTextFont];
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithSubtitleStyleFromTableView:(UITableView *)tableView
{
    static NSString *sCellIdentifier = @"SubtitleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [OHMAppConstants cellTextFont];
        cell.detailTextLabel.font = [OHMAppConstants cellSubtitleTextFont];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithImage:(UIImage *)image text:(NSString *)text fromTableView:(UITableView *)tableView
{
    static NSString *sCellIdentifier = @"ImageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIEdgeInsets insets = kUILabelDefaultInsets;
        CGFloat labelWidth = tableView.frame.size.width - (insets.left + insets.right);
        UILabel *label = [self variableHeightLabelWithText:text width:labelWidth font:[OHMAppConstants cellTextFont] fixedWidth:YES];
        [cell.contentView addSubview:label];
        [label constrainPosition:CGPointMake(insets.left, insets.top)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imageView];
        [imageView constrainSize:CGSizeMake(tableView.frame.size.width, kUICellImageHeight)];
        [imageView constrainPosition:CGPointMake(0, label.frame.size.height + insets.top + insets.bottom)];
    }
    
    return cell;
}

+ (UITableViewCell *)cellWithSwitchFromTableView:(UITableView *)tableView setupBlock:(void (^)(UISwitch *))swBlock
{
    static NSString *sCellIdentifier = @"SwitchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [OHMAppConstants cellTextFont];
        cell.detailTextLabel.font = [OHMAppConstants cellSubtitleTextFont];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 0.75;
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.minimumScaleFactor = 0.75;
        cell.detailTextLabel.numberOfLines = 0;
        
        
        UISwitch *sw = [[UISwitch alloc] init];
        cell.accessoryView = sw;
        if (swBlock) {
            swBlock(sw);
        }
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


+ (UITableViewCell *)cellWithSegmentedControlFromTableView:(UITableView *)tableView setupBlock:(void (^)(UISegmentedControl *sc))scBlock
{
    return nil;
}

+ (UIView *)tableFooterViewWithButton:(NSString *)title fromTableView:(UITableView *)tableView setupBlock:(void (^)(UIButton *))buttonBlock
{
    CGSize buttonSize = CGSizeMake(tableView.frame.size.width - 2 * kUIViewHorizontalMargin, kUIButtonDefaultHeight);
    UIButton *button = [self buttonWithTitle:title color:[OHMAppConstants ohmageColor] target:nil action:nil size:buttonSize];
    CGRect buttonFrame = button.frame;
    
    CGRect footerFrame = CGRectMake(0, 0, tableView.frame.size.width, buttonFrame.size.height + (kUIViewVerticalMargin * 2));
    UIView *footerView = [[UIView alloc] initWithFrame:footerFrame];
    
    [footerView addSubview:button];
    [button centerHorizontallyInView:footerView];
    [button centerVerticallyInView:footerView];
    
    if (buttonBlock) {
        buttonBlock(button);
    }
    
    return footerView;
}


+ (UILabel *)headerTitleLabelWithText:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerTitleFont] fixedWidth:YES];
    label.textColor = [OHMAppConstants headerTitleColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)headerDescriptionLabelWithText:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerDescriptionFont] fixedWidth:YES];
    label.textColor = [OHMAppConstants headerDescriptionColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

+ (UILabel *)headerDetailLabelWithText:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [self variableHeightLabelWithText:text width:width font:[OHMAppConstants headerDetailFont] fixedWidth:YES];
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

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font fixedWidth:(BOOL)fixedWidth
{
    CGSize size = [self sizeForText:text withWidth:width font:font];
    if (fixedWidth) {
        size.width = width;
    }
    return [self baseLabelWithText:text font:font size:size];
}

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    return [self variableHeightLabelWithText:text width:width font:font fixedWidth:NO];
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
    
    frameView.layer.cornerRadius = 6.0;
    frameView.layer.masksToBounds = YES;
    
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

+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)selector size:(CGSize)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    button.titleEdgeInsets = kUIButtonTitleDefaultInsets;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.minimumScaleFactor = 0.5;
    [button constrainSize:size];
    
    button.titleLabel.font = [OHMAppConstants buttonFont];
    
    [button setTitleColor:[OHMAppConstants buttonTextColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [button setTitleColor:[color lightColor] forState:UIControlStateHighlighted];
    
    button.backgroundColor = color;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)selector maxWidth:(CGFloat)maxWidth
{
    UIEdgeInsets insets = kUIButtonTitleDefaultInsets;
    CGFloat titleWidth = maxWidth - (insets.left + insets.right);
    CGSize titleSize = [self sizeForText:title withWidth:titleWidth font:[OHMAppConstants buttonFont]];
    CGSize buttonSize = CGSizeMake(titleSize.width + (insets.left + insets.right), titleSize.height + (insets.top + insets.bottom));
    
    return [self buttonWithTitle:title color:color target:target action:selector size:buttonSize];
}

+ (UIButton *)buttonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target action:(SEL)selector fixedWidth:(CGFloat)fixedWidth
{
    UIEdgeInsets insets = kUIButtonTitleDefaultInsets;
    CGFloat titleWidth = fixedWidth - (insets.left + insets.right);
    CGSize titleSize = [self sizeForText:title withWidth:titleWidth font:[OHMAppConstants buttonFont]];
    CGSize buttonSize = CGSizeMake(fixedWidth, titleSize.height + (insets.top + insets.bottom));
    
    return [self buttonWithTitle:title color:color target:target action:selector size:buttonSize];
}

+ (NSString *)formattedDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMM d h:m" options:0
                                                                  locale:[NSLocale currentLocale]];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];
    }
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)formattedTime:(NSDate *)time
{
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return [dateFormatter stringFromDate:time];
}

@end
