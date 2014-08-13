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
#import "OHMCreateAccountViewController.h"

#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface OHMLoginViewController ()

@property (nonatomic, strong) GPPSignInButton *googleSignInButton;
@property (nonatomic) BOOL didPressGoogleButton;

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
    
    UIButton *emailButton = [OHMUserInterface buttonWithTitle:@"Sign in with E-mail"
                                                        color:[UIColor whiteColor]
                                                       target:self
                                                       action:@selector(emailLoginButtonPressed:)
                                                         size:buttonSize];
    emailButton.backgroundColor = [UIColor whiteColor];
    emailButton.titleLabel.font = [OHMAppConstants boldTextFont];
    [emailButton setTitleColor:[OHMAppConstants ohmageColor] forState:UIControlStateNormal];
    [view addSubview:emailButton];
    
    UIButton *createButton = [OHMUserInterface buttonWithTitle:@"Create Account"
                                                         color:[UIColor whiteColor]
                                                        target:self
                                                        action:@selector(createAccountButtonPressed:)
                                                          size:buttonSize];
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
    
    [emailButton constrainToBottomInParentWithMargin:buttonMargin];
    [createButton constrainToBottomInParentWithMargin:buttonMargin];
    
    GPPSignInButton *googleButton = [[GPPSignInButton alloc] init];
    [googleButton addTarget:self action:@selector(googleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    googleButton.style = kGPPSignInButtonStyleWide;
    [view addSubview:googleButton];
    [view constrainChildToDefaultHorizontalInsets:googleButton];
    [googleButton positionAboveElement:emailButton withMargin:buttonMargin];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[OHMClient sharedClient] gppSignIn]; // make sure shared instance is setup
    [OHMClient sharedClient].googleSignInCompletionBlock = ^(BOOL success, NSString *errorString) {
        if (success) {
            [self dismissRecursive];
        }
        else {
            [self presentLoginError];
        }
    };

}

- (void)emailLoginButtonPressed:(id)sender
{
    OHMEmailLoginViewController *vc = [[OHMEmailLoginViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)createAccountButtonPressed:(id)sender
{
    OHMCreateAccountViewController *vc = [[OHMCreateAccountViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)googleButtonPressed:(id)sender
{
    self.didPressGoogleButton = YES;
}

- (void)presentLoginError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed"
                                                    message:@"Unable to sign in"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)dismissRecursive
{
    UIViewController *presenter = self.presentingViewController;
    while (presenter.presentingViewController) {
        presenter = presenter.presentingViewController;
    }
    [presenter dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentSignInViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
