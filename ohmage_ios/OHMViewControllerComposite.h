//
//  OHMViewControllerComposite.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHMUserInterface.h"

@interface OHMViewControllerComposite : NSObject <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIBarButtonItem *cancelModalPresentationButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, readonly) CGFloat topLength;
@property (nonatomic) BOOL backgroundTapEnabled;

- (id)initWithViewController:(UIViewController *)viewController;

- (void)commonSetup;

- (void)setBackButtonTitle:(NSString *)title;

- (void)cancelModalPresentationButtonPressed:(id)sender;
- (void)prepareForModalPresentation;

// it seems "respondsToSelector" returns no unless these are publicly declared
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
