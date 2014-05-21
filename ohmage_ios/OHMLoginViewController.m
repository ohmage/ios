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

@interface OHMLoginViewController () <GPPSignInDelegate>

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
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    signIn.clientID = kGoogleClientId;
    signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign In Failed" message:@"Unable to sign in" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Google Login Delegate

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (!error) {
        [[OHMClient sharedClient] loginWithGoogleAuth:auth completionBlock:^(BOOL success) {
            if (success) {
    
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                [self presentLoginError];
            }
        }];
    }
    else if (self.didPressGoogleButton) { //don't present error for silent auth failure
        [self presentLoginError];
    }
}

- (void)presentSignInViewController:(UIViewController *)viewController {
    // This is an example of how you can implement it if your app is navigation-based.
//    [[self navigationController] pushViewController:viewController animated:YES];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
