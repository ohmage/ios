//
//  OHMViewControllerCompositeProtocol.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OHMViewControllerCompositeProtocol <NSObject, UITextViewDelegate, UITextFieldDelegate>

@optional

@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *cancelModalPresentationButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, readonly) CGFloat topLength;

- (id)initWithViewController:(UIViewController *)viewController;

- (void)commonSetup;

- (void)setBackButtonTitle:(NSString *)title;
- (void)setupForTextEntry;

- (void)doneButtonPressed:(id)sender;
- (void)cancelModalPresentationButtonPressed:(id)sender;

- (void)prepareForModalPresentation;

- (void)presentConfirmationAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                             confirmTitle:(NSString *)confirmTitle;
- (void)confirmationAlertDidConfirm:(UIAlertView *)alert;

@end
