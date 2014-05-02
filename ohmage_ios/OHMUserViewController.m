//
//  OHMUserViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMUserViewController.h"
#import "OHMUser.h"
#import "OHMLoginViewController.h"

@interface OHMUserViewController ()

@property (nonatomic, strong) OHMUser *user;

@end

@implementation OHMUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"User Info";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(cancelModalPresentationButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.user = [[OHMClient sharedClient] loggedInUser];
    [self setupHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    self.navigationController.navigationBar.barTintColor = [OHMAppConstants ohmageColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logoutButtonPressed:(id)sender
{
    [[OHMClient sharedClient] logout];
    OHMLoginViewController *vc = [[OHMLoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setupHeader
{
    
    CGFloat contentWidth = self.tableView.bounds.size.width - 2 * kUIViewHorizontalMargin;
    CGFloat contentHeight = kUIViewVerticalMargin;
    
    UILabel *nameLabel = [OHMUserInterface headerTitleLabelWithText:self.user.fullName width:contentWidth];
    contentHeight += nameLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UILabel *emailLabel = [OHMUserInterface headerDescriptionLabelWithText:self.user.email width:contentWidth];
    contentHeight += emailLabel.frame.size.height + kUIViewVerticalMargin;
    
    UIButton *button = [OHMUserInterface buttonWithTitle:@"Sign Out" target:self action:@selector(logoutButtonPressed:) maxWidth:contentWidth];
    button.backgroundColor = [OHMAppConstants ohmageColor];
    contentHeight += button.frame.size.height + kUIViewVerticalMargin;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, contentHeight)];
    headerView.backgroundColor = [OHMAppConstants lightOhmageColor];
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:emailLabel];
    [headerView addSubview:button];
    
    [nameLabel centerHorizontallyInView:headerView];
    [emailLabel centerHorizontallyInView:headerView];
    [button centerHorizontallyInView:headerView];
    
    [nameLabel constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [emailLabel positionBelowElement:nameLabel margin:kUIViewSmallTextMargin];
    [button positionBelowElement:emailLabel margin:kUIViewVerticalMargin];
    
    self.tableView.tableHeaderView = headerView;
}


@end
