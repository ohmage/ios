//
//  OHMViewControllerComposite.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMViewControllerComposite.h"

@interface OHMViewControllerComposite ()

@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGesture;

@end

@implementation OHMViewControllerComposite

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [self init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)commonSetup
{
}

- (void)backgroundTapped:(id)sender
{
    [self.viewController.view endEditing:YES];
}

- (void)setBackgroundTapEnabled:(BOOL)backgroundTapEnabled
{
    if (backgroundTapEnabled) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        tap.cancelsTouchesInView = NO;
        [self.viewController.view addGestureRecognizer:tap];
        self.backgroundTapGesture = tap;
    }
    else {
        [self.viewController.view removeGestureRecognizer:self.backgroundTapGesture];
        self.backgroundTapGesture = nil;
    }
}

- (void)prepareForModalPresentation
{
    self.viewController.navigationItem.leftBarButtonItem = self.cancelModalPresentationButton;
    self.viewController.navigationItem.rightBarButtonItem = nil;
}

- (UIBarButtonItem *)cancelModalPresentationButton
{
    if (_cancelModalPresentationButton == nil) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                         style:UIBarButtonItemStyleBordered
                                                                        target:self
                                                                        action:@selector(cancelModalPresentationButtonPressed:)];
        _cancelModalPresentationButton = cancelButton;
    }
    return _cancelModalPresentationButton;
}

- (void)setBackButtonTitle:(NSString *)title
{
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
    self.viewController.navigationItem.backBarButtonItem = backButtonItem;
}

- (void)helpButtonPressed:(id)sender
{
    
}

- (void)cancelModalPresentationButtonPressed:(id)sender
{
    [self.viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)topLength
{
    CGFloat topLength = 0.0;
    if( self.viewController.navigationController != nil ) {
        topLength += self.viewController.navigationController.navigationBar.bounds.size.height;
    }
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        topLength += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return topLength;
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.backgroundTapEnabled = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.backgroundTapEnabled = NO;
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.backgroundTapEnabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.backgroundTapEnabled = NO;
}

@end

