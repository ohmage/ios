//
//  OHMViewControllerComposite.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMUserInterface.h"
#import "OHMViewControllerCompositeProtocol.h"

@interface OHMViewControllerComposite : NSObject <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIViewController<OHMViewControllerCompositeProtocol> *viewController;

@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *cancelModalPresentationButton;
@property (nonatomic, readonly) CGFloat topLength;
@property (nonatomic) BOOL backgroundTapEnabled;

- (id)initWithViewController:(UIViewController<OHMViewControllerCompositeProtocol> *)viewController;

- (void)commonSetup;

- (void)setBackButtonTitle:(NSString *)title;

- (void)doneButtonPressed:(id)sender;
- (void)cancelModalPresentationButtonPressed:(id)sender;
- (void)prepareForModalPresentation;

- (void)presentConfirmationAlertWithTitle:(NSString *)title
                                  message:(NSString *)message
                             confirmTitle:(NSString *)confirmTitle;
- (void)confirmationAlertDidConfirm:(UIAlertView *)alert;

// it seems "respondsToSelector" returns no unless these are publicly declared
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
