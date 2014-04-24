//
//  OHMSurveyTableViewCell.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/4/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyTableViewCell.h"

@interface OHMSurveyTableViewCell () 

@end

@implementation OHMSurveyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.numberOfLines = 0;
        self.detailTextLabel.numberOfLines = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)cellHeight
{
    CGSize detailSize = [self.detailTextLabel.text sizeWithAttributes:nil];
    return detailSize.height;
}


@end
