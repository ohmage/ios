//
//  OHMCreateAccountViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/15/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMCreateAccountViewController.h"

@interface OHMCreateAccountViewController ()

@property (nonatomic, weak) UIView *contentBox;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *createAccountButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation OHMCreateAccountViewController


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
    header.text = @"Create an ohmage account";
    header.textColor = [OHMAppConstants ohmageColor];
    header.font = [OHMAppConstants headerTitleFont];
    header.textAlignment = NSTextAlignmentCenter;
    [contentBox addSubview:header];
    [header constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [contentBox constrainChild:header toHorizontalInsets:kUIViewDefaultInsets];
    
    UIView *nameField = [OHMUserInterface textFieldWithLabelText:@"FULL NAME" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"enter your name";
        tf.delegate = self;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.nameTextField = tf;
    }];
    
    UIView *emailField = [OHMUserInterface textFieldWithLabelText:@"E-MAIL" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"enter your e-mail";
        tf.delegate = self;
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.emailTextField = tf;
    }];
    
    UIView *passwordField = [OHMUserInterface textFieldWithLabelText:@"PASSWORD" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"enter your password";
        tf.secureTextEntry = YES;
        tf.delegate = self;
        self.passwordTextField = tf;
    }];
    
    [contentBox addSubview:nameField];
    [contentBox addSubview:emailField];
    [contentBox addSubview:passwordField];
    
    [nameField positionBelowElement:header margin:kUIViewVerticalMargin];
    [emailField positionBelowElement:nameField margin:kUIViewVerticalMargin];
    [passwordField positionBelowElement:emailField margin:kUIViewVerticalMargin];
    
    [contentBox constrainChild:nameField toHorizontalInsets:kUIViewDefaultInsets];
    [contentBox constrainChild:emailField toHorizontalInsets:kUIViewDefaultInsets];
    [contentBox constrainChild:passwordField toHorizontalInsets:kUIViewDefaultInsets];
    
    CGFloat buttonWidth = screenBounds.size.width - 2 * kUIViewSmallMargin - 2 * kUIViewHorizontalMargin;
    CGSize buttonSize = CGSizeMake(buttonWidth, kUIButtonDefaultHeight);
    UIButton *createAccountButton = [OHMUserInterface buttonWithTitle:@"Create Account"
                                                         color:[OHMAppConstants ohmageColor]
                                                        target:self
                                                        action:@selector(createAccountButtonPressed:)
                                                          size:buttonSize];
    createAccountButton.enabled = NO;
    self.createAccountButton = createAccountButton;
    
    [contentBox addSubview:createAccountButton];
    [createAccountButton positionBelowElement:passwordField margin:kUIViewVerticalMargin];
    [createAccountButton centerHorizontallyInView:contentBox];
    [createAccountButton constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    
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

- (void)presentLoginError:(NSString *)errorString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Account Failed" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)createAccountButtonPressed:(id)sender
{
    [[OHMClient sharedClient] createAccountWithName:self.nameTextField.text
                                              email:self.emailTextField.text
                                           password:self.passwordTextField.text
                                    completionBlock:^(BOOL success, NSString *errorString) {
        if (success) {
            [self dismissRecursive];
        }
        else {
            [self.activityIndicator stopAnimating];
            [UIView animateWithDuration:0.5 animations:^{
                self.activityIndicator.alpha = 0.0;
            }];
            [self presentLoginError:errorString];
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
    
    self.createAccountButton.enabled = ( (self.nameTextField.text.length > 0)
                                        && (self.emailTextField.text.length > 0)
                                        && (self.passwordTextField.text.length > 0) );
}

@end
