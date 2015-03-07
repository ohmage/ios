//
//  DSUURLViewController.m
//  PAM
//
//  Created by Charles Forkish on 2/15/15.
//  Copyright (c) 2015 Charlie Forkish. All rights reserved.
//

#import "DSUURLViewController.h"
#import "OMHClient.h"
#import "UIView+AutoLayoutHelpers.h"

@interface DSUURLViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UIBarButtonItem *resetButton;

@end

@implementation DSUURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Set Server Name";
    
    self.view.backgroundColor = [OHMAppConstants ohmageColor];
    
    UILabel *warning = [[UILabel alloc] init];
    warning.numberOfLines = 0;
    warning.text = @"Do not modify this server name unless you have been instructed by a researcher to do so.";
    [warning sizeToFit];
    
    UIView *frame = [[UIView alloc] init];
    frame.backgroundColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0];
    frame.layer.cornerRadius = 8.0;
    [self.view addSubview:frame];
    [self.view constrainChildToDefaultHorizontalInsets:frame];
    [frame positionBelowElementWithDefaultMargin:self.topLayoutGuide];
    
    [frame addSubview:warning];
    [frame constrainChildToDefaultInsets:warning];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.delegate = self;
    tf.text = [OMHClient DSUBaseURL];
    tf.backgroundColor = [UIColor whiteColor];
    tf.borderStyle = UITextBorderStyleBezel;
    tf.adjustsFontSizeToFitWidth = YES;
    tf.minimumFontSize = 6.0;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.view addSubview:tf];
    [self.view constrainChildToDefaultHorizontalInsets:tf];
    [tf positionBelowElementWithDefaultMargin:frame];
    
    self.textField = tf;
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(cancelButtonPressed:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(doneButtonPressed:)];
    doneButton.enabled = NO;
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset Server Name" style:UIBarButtonItemStylePlain target:self action:@selector(resetURL)];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[spacer1, resetButton, spacer2];
    self.navigationController.toolbarHidden = NO;
    self.resetButton = resetButton;
    resetButton.enabled = ![self.textField.text isEqualToString:[OMHClient defaultDSUBaseURL]];
}

- (void)resetURL
{
    self.textField.text = [OMHClient defaultDSUBaseURL];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)doneButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    
    NSString *title = @"Confirm Server Name";
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to set the server name to %@?", self.textField.text];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Confirm", nil];
    [alert show];
}

- (void)cancelButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length > 0) {
        if (![textField.text isEqualToString:[OMHClient DSUBaseURL]]) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        if ([textField.text isEqualToString:[OMHClient defaultDSUBaseURL]]) {
            self.resetButton.enabled = NO;
        }
        else {
            self.resetButton.enabled = YES;
        }
    }
    else {
        textField.text = [OMHClient DSUBaseURL];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [OMHClient setDSUBaseURL:self.textField.text];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}



@end
