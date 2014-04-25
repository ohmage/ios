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

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = font;
    label.text = text;
    CGSize size = [self sizeForText:text withWidth:width font:font];
    [label constrainSize:size];
    
    return label;
}

+ (void)applyRoundedBorderToView:(UIView *)view
{
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.borderColor = [UIColor clearColor].CGColor;// [UIColor colorWithWhite:0.72 alpha:1.0].CGColor;
//    view.layer.borderWidth = 3.0f;
    view.layer.cornerRadius = 12;
    // This has to be 'NO' for shadows to work.
    view.layer.masksToBounds = YES;
//    view.layer.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
//    view.layer.shadowOffset = CGSizeMake(0.0, 1.0);
//    view.layer.shadowRadius = 0;
//    view.layer.shadowOpacity = 1.0;
}

@end
