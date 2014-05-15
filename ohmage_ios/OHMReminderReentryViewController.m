//
//  OHMReminderReentryViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/15/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMReminderReentryViewController.h"
#import "OHMReminder.h"

@interface OHMReminderReentryViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) OHMReminder *reminder;

@end

@implementation OHMReminderReentryViewController

- (instancetype)initWithReminder:(OHMReminder *)reminder
{
    self = [super init];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Minutes";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearsOnBeginEditing = YES;
    textField.placeholder = @"Enter number of minutes";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.enablesReturnKeyAutomatically = YES;
    textField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:textField];
    [self.view constrainChildToDefaultHorizontalInsets:textField];
    [textField positionBelowElement:self.topLayoutGuide margin:kUIViewVerticalMargin];
    
    self.textField = textField;
    [self updateTextfield];
}

- (void)updateTextfield
{
    self.textField.text = [NSString stringWithFormat:@"%d minutes", self.reminder.minimumReentryIntervalValue];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // call to "super"
    [self.viewControllerComposite textFieldDidEndEditing:textField];
    
    if (textField.text.length > 0) {
        int interval = [textField.text intValue];
        self.reminder.minimumReentryIntervalValue = interval;
    }
    
    [self updateTextfield];
}

@end
