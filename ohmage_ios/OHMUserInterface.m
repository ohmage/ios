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
    
    CGSize constraintSize = CGSizeMake([self cellContentWidthForAccessoryType:accessoryType] - kUIViewHorizontalMargin, CGFLOAT_MAX);
    CGRect titleRect = [title boundingRectWithSize:constraintSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:titleFont}
                                          context:nil];
    
    CGRect subtitleRect = [subtitle boundingRectWithSize:constraintSize
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:subtitleFont}
                                           context:nil];
    
    CGSize titleSize = [self ceilSize:titleRect.size];
    CGSize subtitleSize = [self ceilSize:subtitleRect.size];
    
    return MAX(titleSize.height + subtitleSize.height + kUIViewVerticalMargin, tableView.rowHeight);
}

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width
{
    return nil;
}

+ (void)applyRoundedBorderToView:(UIView *)view
{
//    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor colorWithWhite:0.72 alpha:1.0].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 8;
    // This has to be 'NO' for shadows to work.
    // view.layer.masksToBounds = YES;
    view.layer.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    view.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    view.layer.shadowRadius = 0;
    view.layer.shadowOpacity = 1.0;
}

@end
