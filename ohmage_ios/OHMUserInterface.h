//
//  OHMUserInterface.h
//  ohmage_ios
//
//  Created by Charles Forkish on 4/24/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHMUserInterface : NSObject

+ (CGFloat)heightForSubtitleCellWithTitle:(NSString *)title
                                 subtitle:(NSString *)subtitle
                            accessoryType:(UITableViewCellAccessoryType)accessoryType
                            fromTableView:(UITableView *)tableView;

+ (UILabel *)variableHeightLabelWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;

+ (void)applyRoundedBorderToView:(UIView *)view;

@end
