//
//  OHMDetailViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMDetailViewController.h"

@interface OHMDetailViewController ()

@end

@implementation OHMDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setTableHeaderView:self.headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)headerView
{
    // If you have not loaded the headerView yet...
    if (!_headerView) {
        
        // Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"OHMDetailHeaderView"
                                      owner:self
                                    options:nil];
    }
    
    return _headerView;
}

- (IBAction)rightButtonPressed:(id)sender {
}
- (IBAction)leftButtonPressed:(id)sender {
}
@end
