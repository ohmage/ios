//
//  OHMEmailLoginViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMEmailLoginViewController.h"
#import "OHMUserInterface.h"

@interface OHMEmailLoginViewController ()

@property (nonatomic, weak) UIView *contentBox;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *signInButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation OHMEmailLoginViewController


- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    view.backgroundColor = [OHMAppConstants ohmageColor];
    self.view = view;
    
    UIView *contentBox = [[UIView alloc] init];
    contentBox.backgroundColor = [UIColor whiteColor];
    [view addSubview:contentBox];
    [view constrainChild:contentBox toHorizontalInsets:UIEdgeInsetsMake(0, kUIViewSmallMargin, 0, kUIViewSmallMargin)];
    self.contentBox = contentBox;
    
    UILabel *header = [[UILabel alloc] init];
    header.text = @"Sign in with E-mail";
    header.textColor = [OHMAppConstants ohmageColor];
    header.font = [OHMAppConstants headerTitleFont];
    header.textAlignment = NSTextAlignmentCenter;
    [contentBox addSubview:header];
    [header constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [contentBox constrainChild:header toHorizontalInsets:kUIViewDefaultInsets];
    
    UIView *emailField = [OHMUserInterface textFieldWithLabelText:@"E-MAIL" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"enter your e-mail";
        tf.delegate = self;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.emailTextField = tf;
        
        //debug
        tf.text = @"cforkish@gmail.com";
    }];
    
    UIView *passwordField = [OHMUserInterface textFieldWithLabelText:@"PASSWORD" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"enter your password";
        tf.secureTextEntry = YES;
        tf.delegate = self;
        self.passwordTextField = tf;
        
        //debug
        tf.text = @"loudfowl98";
    }];
    
    [contentBox addSubview:emailField];
    [contentBox addSubview:passwordField];
    
    [emailField positionBelowElement:header margin:kUIViewVerticalMargin];
    [passwordField positionBelowElement:emailField margin:kUIViewVerticalMargin];
    
    [contentBox constrainChild:emailField toHorizontalInsets:kUIViewDefaultInsets];
    [contentBox constrainChild:passwordField toHorizontalInsets:kUIViewDefaultInsets];
    
    CGFloat buttonWidth = screenBounds.size.width - 2 * kUIViewSmallMargin - 2 * kUIViewHorizontalMargin;
    CGSize buttonSize = CGSizeMake(buttonWidth, kUIButtonDefaultHeight);
    UIButton *signInButton = [OHMUserInterface buttonWithTitle:@"Sign In"
                                                         color:[OHMAppConstants ohmageColor]
                                                        target:self
                                                        action:@selector(signInButtonPressed:)
                                                          size:buttonSize];
    signInButton.enabled = (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0);
    self.signInButton = signInButton;
    
    [contentBox addSubview:signInButton];
    [signInButton positionBelowElement:passwordField margin:kUIViewVerticalMargin];
    [signInButton centerHorizontallyInView:contentBox];
    [signInButton constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:activityIndicator];
    [activityIndicator centerHorizontallyInView:view];
    [activityIndicator positionBelowElement:contentBox margin:2 * kUIViewVerticalMargin];
    activityIndicator.alpha = 0;
    self.activityIndicator = activityIndicator;
    
    
    UIButton *cancelButton = [OHMUserInterface buttonWithTitle:@"Cancel"
                                                         color:[UIColor clearColor]
                                                        target:self
                                                        action:@selector(cancelModalPresentationButtonPressed:)
                                                          size:buttonSize];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [view addSubview:cancelButton];
    [cancelButton constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    [cancelButton centerHorizontallyInView:view];
//    [view constrainChild:cancelButton toHorizontalInsets:kUIViewDefaultInsets];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentBox positionBelowElement:self.topLayoutGuide margin:kUIViewVerticalMargin];
}

- (void)dismissRecursive
{
    UIViewController *presenter = self.presentingViewController;
    while (presenter.presentingViewController) {
        presenter = presenter.presentingViewController;
    }
    [presenter dismissViewControllerAnimated:YES completion:nil];
}

- (void)signInButtonPressed:(id)sender
{
    [[OHMClient sharedClient] loginWithEmail:self.emailTextField.text password:self.passwordTextField.text completionBlock:^(BOOL success) {
        if (success) {
            [self dismissRecursive];
//            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.activityIndicator stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                self.activityIndicator.alpha = 0.0;
            }];
        }
    }];
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.activityIndicator.alpha = 1.0;
    }];
}

#pragma mark - TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // call to "super"
    [self.viewControllerComposite textFieldDidEndEditing:textField];
    
    self.signInButton.enabled = (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0);
}

@end
