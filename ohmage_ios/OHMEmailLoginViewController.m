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

@end

@implementation OHMEmailLoginViewController


- (void)loadView
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:screenBounds];
    view.backgroundColor = [OHMAppConstants ohmageColor];
    
    UIView *contentBox = [[UIView alloc] init];
    contentBox.backgroundColor = [UIColor whiteColor];
    [view addSubview:contentBox];
    [view constrainChild:contentBox toHorizontalInsets:UIEdgeInsetsMake(0, kUIViewSmallMargin, 0, kUIViewSmallMargin)];
    
    UILabel *header = [[UILabel alloc] init];
    header.text = @"Sign in with E-mail";
    header.textColor = [OHMAppConstants ohmageColor];
    header.font = [OHMAppConstants headerTitleFont];
    header.textAlignment = NSTextAlignmentCenter;
    [contentBox addSubview:header];
    [header constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [contentBox constrainChild:header toHorizontalInsets:kUIViewDefaultInsets];
    
    UIView *emailField = [OHMUserInterface textFieldWithLabelText:@"E-MAIL" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"Enter your E-mail";
    }];
    
    UIView *passwordField = [OHMUserInterface textFieldWithLabelText:@"PASSWORD" setupBlock:^(UITextField *tf) {
        tf.placeholder = @"Enter your password";
        tf.secureTextEntry = YES;
    }];
    
    [contentBox addSubview:emailField];
    [contentBox addSubview:passwordField];
    
    [emailField positionBelowElement:header margin:kUIViewVerticalMargin];
    [passwordField positionBelowElement:emailField margin:kUIViewVerticalMargin];
    
    [contentBox constrainChild:emailField toHorizontalInsets:kUIViewDefaultInsets];
    [contentBox constrainChild:passwordField toHorizontalInsets:kUIViewDefaultInsets];
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    signInButton.backgroundColor = [OHMAppConstants ohmageColor];
    
    [contentBox addSubview:signInButton];
    [signInButton positionBelowElement:passwordField margin:kUIViewVerticalMargin];
    [contentBox constrainChild:signInButton toHorizontalInsets:kUIViewDefaultInsets];
    [signInButton constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [view addSubview:cancelButton];
    [cancelButton constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    [view constrainChild:cancelButton toHorizontalInsets:kUIViewDefaultInsets];
    
    self.view = view;
    self.contentBox = contentBox;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.contentBox positionBelowElement:self.topLayoutGuide margin:kUIViewVerticalMargin];
}

@end
