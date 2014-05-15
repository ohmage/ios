//
//  OHMReminderReentryViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/15/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderReentryViewController.h"

@interface OHMReminderReentryViewController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation OHMReminderReentryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Minutes";
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = @"Enter number of minutes";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.enablesReturnKeyAutomatically = YES;
    textField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:textField];
    [self.view constrainChildToDefaultHorizontalInsets:textField];
    [textField constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    
    self.textField = textField;
}

@end
