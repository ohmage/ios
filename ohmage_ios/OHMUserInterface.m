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

@end
