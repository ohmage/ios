//
//  OHMLoginViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMLoginViewController.h"
#import "OHMAppDelegate.h"
#import "OMHClient.h"
#import "OHMModel.h"
#import "DSUURLViewController.h"

@interface OHMLoginViewController () <OMHSignInDelegate>

@property (nonatomic, weak) UIButton *signInButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *signInFailureLabel;

@end

@implementation OHMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [OHMAppConstants ohmageColor];
    UIImage *launchImage = [UIImage imageNamed:@"login_bg"];
    UIImageView *background = [[UIImageView alloc] initWithImage:launchImage];
    [self.view addSubview:background];
    [self.view constrainChildToEqualSize:background];
    
    UIButton *settings = [UIButton buttonWithType:UIButtonTypeSystem];
    settings.tintColor = [UIColor whiteColor];
    [settings setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settings addTarget:self action:@selector(presentSettingsViewController) forControlEvents:UIControlEventTouchUpInside];
    [settings constrainSize:CGSizeMake(25, 25)];
    [self.view addSubview:settings];
    [settings constrainToLeftInParentWithMargin:10];
    [settings constrainToBottomInParentWithMargin:10];
    
    [self setupSignInButton];
}

- (void)setupSignInButton
{
    if (self.signInButton) {
        [self.signInButton removeFromSuperview];
        self.signInButton = nil;
    }
    
    UIButton *googleButton = [OMHClient googleSignInButton];
    [googleButton addTarget:self action:@selector(signInButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:googleButton];
    [self.view constrainChildToDefaultHorizontalInsets:googleButton];
    [googleButton constrainToBottomInParentWithMargin:80];
    
    [OMHClient sharedClient].signInDelegate = self;
    self.signInButton = googleButton;
}

- (void)signInButtonPressed:(id)sender
{
    if (self.signInFailureLabel != nil) {
        [self.signInFailureLabel removeFromSuperview];
        self.signInFailureLabel = nil;
    }
    
    self.signInButton.userInteractionEnabled = NO;
    self.signInButton.alpha = 0.7;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:indicator];
    [indicator centerHorizontallyInView:self.view];
    [indicator positionAboveElement:self.signInButton withMargin:self.signInButton.frame.size.height];
    [indicator startAnimating];
    self.activityIndicator = indicator;
}

- (void)presentSignInFailureMessage
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Sign in failed";
    [label sizeToFit];
    [self.view addSubview:label];
    [label centerHorizontallyInView:self.view];
    [label positionAboveElement:self.signInButton withMargin:self.signInButton.frame.size.height];
    self.signInFailureLabel = label;
}

- (void)presentSettingsViewController
{
    DSUURLViewController *vc = [[DSUURLViewController alloc] init];
    UINavigationController *navcon = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navcon animated:YES completion:nil];
}

- (void)OMHClient:(OMHClient *)client signInFinishedWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    
    if (error != nil) {
        NSLog(@"OMHClientLoginFinishedWithError: %@", error);
        [self setupSignInButton];
        [self presentSignInFailureMessage];
    }
    else {
        [[OHMModel sharedModel] clientDidLoginWithEmail:[OMHClient signedInUserEmail]];
    
        if (self.presentingViewController != nil) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [(OHMAppDelegate *)[UIApplication sharedApplication].delegate userDidLogin];
        }
    }
}

@end
