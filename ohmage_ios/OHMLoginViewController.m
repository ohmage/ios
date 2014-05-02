//
//  OHMLoginViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMLoginViewController.h"
#import "OHMUserInterface.h"
#import "OHMEmailLoginViewController.h"

@interface OHMLoginViewController ()

@end

@implementation OHMLoginViewController

- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    view.backgroundColor = [OHMAppConstants ohmageColor];
    UIImage *launchImage = [UIImage imageNamed:@"login_bg"];
    UIImageView *background = [[UIImageView alloc] initWithImage:launchImage];
    [view addSubview:background];
    [view constrainChildToEqualSize:background];
    
    CGFloat buttonMargin = kUIViewSmallMargin;
    CGFloat buttonWidth = (screenBounds.size.width - 3 * buttonMargin) / 2.0;
    CGSize buttonSize = CGSizeMake(buttonWidth, kUIButtonDefaultHeight);
    
    UIButton *emailButton = [OHMUserInterface buttonWithTitle:@"Sign in with E-mail" target:self action:@selector(emailLoginButtonPressed:) size:buttonSize];
    emailButton.backgroundColor = [UIColor whiteColor];
    emailButton.titleLabel.font = [OHMAppConstants boldTextFont];
    [emailButton setTitleColor:[OHMAppConstants ohmageColor] forState:UIControlStateNormal];
    [view addSubview:emailButton];
    
    UIButton *createButton = [OHMUserInterface buttonWithTitle:@"Create Account" target:nil action:nil size:buttonSize];
    createButton.titleEdgeInsets = kUIButtonTitleSmallInsets;
    createButton.backgroundColor = [UIColor whiteColor];
    createButton.titleLabel.font = [OHMAppConstants boldTextFont];
    [createButton setTitleColor:[OHMAppConstants ohmageColor] forState:UIControlStateNormal];
    [view addSubview:createButton];
    
    emailButton.translatesAutoresizingMaskIntoConstraints = createButton.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-margin-[emailButton]-margin-[createButton]-margin-|"
                          options:0
                          metrics:@{@"margin": @(buttonMargin)}
                          views:NSDictionaryOfVariableBindings(emailButton, createButton)]];
    
//    [view layoutChildrenHorizontallyWithDefaultMargins:@[emailButton, createButton]];
    [emailButton constrainToBottomInParentWithMargin:buttonMargin];
    [createButton constrainToBottomInParentWithMargin:buttonMargin];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)emailLoginButtonPressed:(id)sender
{
    OHMEmailLoginViewController *vc = [[OHMEmailLoginViewController alloc] init];
//    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
