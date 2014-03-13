//
//  OHMProjectDetailViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMProjectDetailViewController.h"
#import "OHMProject.h"

@interface OHMProjectDetailViewController ()

@end

@implementation OHMProjectDetailViewController

- (id)initWithProject:(OHMProject*)project
{
    self = [super init];
    if (self) {
        _project = project;
    }
    return self;
}

- (void)setupHeader
{
    self.headerIconView.image = [UIImage imageNamed:@"apple_logo"];
    self.headerTitleLabel.text = self.project.name;
    self.headerSubtitleLabel.text = self.project.urn;
    
    [self.leftButton setImage:[UIImage imageNamed:@"pencilpaper"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    
    [self.rightButton setTitle:@"Remove" forState:UIControlStateNormal];
    [self.leftButton setTitle:@"View Surveys" forState:UIControlStateNormal];
    
    [self.rightButton sizeToFit];
    [self.leftButton sizeToFit];
    
//    [self.headerView setNeedsDisplay];
}

- (void)setProject:(OHMProject *)project
{
    _project = project;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupHeader];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
