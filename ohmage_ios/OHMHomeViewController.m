//
//  OHMHomeViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMHomeViewController.h"
#import "OHMProjectsViewController.h"

@interface OHMHomeViewController ()

@end

@implementation OHMHomeViewController

- (IBAction)projectsButtonPressed:(id)sender {
    OHMProjectsViewController *pvc = [[OHMProjectsViewController alloc] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (IBAction)surveysButtonPressed:(id)sender {
}
- (IBAction)responseHistoryButtonPressed:(id)sender {
}
- (IBAction)uploadQueueButtonPressed:(id)sender {
}
- (IBAction)profileButtonPressed:(id)sender {
}
- (IBAction)mobilityButtonPressed:(id)sender {
}
- (IBAction)streamsButtonPressed:(id)sender {
}
- (IBAction)helpButtonPressed:(id)sender {
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Home";
        navItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_logo_default"]];
        navItem.titleView.isAccessibilityElement = YES;
        navItem.titleView.accessibilityTraits = UIAccessibilityTraitHeader | UIAccessibilityTraitStaticText;
        navItem.titleView.accessibilityLabel = @"Ohmage Home";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
