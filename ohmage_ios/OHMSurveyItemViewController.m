//
//  OHMSurveyItemViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyItemViewController.h"
#import "OHMSurvey.h"
#import "OHMSurveyResponse.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMUserInterface.h"
#import "OHMSurveyPromptChoice.h"

@interface OHMSurveyItemViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (nonatomic) BOOL backgroundTapEnabled;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGesture;
@property (nonatomic, strong) UIView *validationMessageView;

// Number prompt
@property (weak, nonatomic) UISegmentedControl *numberPlusMinusControl;

@property (nonatomic, strong) OHMSurveyItem *item;

@end

@implementation OHMSurveyItemViewController

+ (instancetype)viewControllerForSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index
{
    return [[OHMSurveyItemViewController alloc] initWithSurveyResponse:response atQuestionIndex:index];
}

- (id)initWithSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index
{
//    self = [super initWithNibName:nil bundle:nil];
    self = [super init];
    if (self) {
        self.surveyResponse = response;
        self.itemIndex = index;
        self.item = self.surveyResponse.survey.surveyItems[self.itemIndex];
    }
    return self;
}

- (void)loadView
{
    [self commonSetup];
    
    if ([self itemNeedsTextField]) {
        [self setupTextField];
    }
    
    if ([self itemNeedsChoiceTable]) {
        [self setupChoiceTable];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view did load with item: %@", self.item.description);
    
    id<UILayoutSupport> topGuide = self.topLayoutGuide;
    id<UILayoutSupport> bottomGuide = self.bottomLayoutGuide;
    [self.textLabel positionBelowElementWithDefaultMargin:topGuide];
    [self.toolbar positionAboveElementWithDefaultMargin:bottomGuide];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %ld", self.itemIndex + 1, [self.surveyResponse.survey.surveyItems count]];
    
    self.textLabel.text = self.item.text;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    UIColor *color = [OHMAppConstants colorForRowIndex:self.surveyResponse.survey.colorIndex];
    self.navigationController.navigationBar.barTintColor = color;
    self.toolbar.barTintColor = color;
    self.toolbar.tintColor = [UIColor whiteColor];
}


#pragma mark - Setup

- (void)commonSetup
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = self.item.text;
    [view addSubview:textLabel];
    [view constrainChildToDefaultHorizontalInsets:textLabel];
    self.textLabel = textLabel;
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [view addSubview:toolbar];
    [view constrainChild:toolbar toHorizontalInsets:UIEdgeInsetsZero];
    self.toolbar = toolbar;
    
    NSMutableArray *barItems = [NSMutableArray array];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    backButton.enabled = (self.itemIndex > 0);
    [barItems addObject:backButton];
    [barItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    self.backButton = backButton;
    
    if (self.item.skippableValue) {
        UIBarButtonItem *skipButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(skipButtonPressed:)];
        [barItems addObject:skipButton];
        [barItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
        self.skipButton = skipButton;
    }
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonPressed:)];
    nextButton.enabled = ((self.item.itemTypeValue == OHMSurveyItemTypeMessage) || self.item.hasDefaultResponse);
    [barItems addObject:nextButton];
    self.nextButton = nextButton;
    
    toolbar.items = barItems;
}

- (BOOL)itemNeedsTextField
{
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeNumberPrompt:
        case OHMSurveyItemTypeTextPrompt:
            return YES;
        default:
            return NO;
    }
}

- (void)setupTextField
{
    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.placeholder = [self textFieldPlaceholder];
    textField.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:textField];
    [self.view constrainChildToDefaultHorizontalInsets:textField];
    [textField positionBelowElementWithDefaultMargin:self.textLabel];
    self.textField = textField;
    
    if (self.item.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
        textField.keyboardType = (self.item.wholeNumbersOnlyValue ? UIKeyboardTypeNumberPad : UIKeyboardTypeDecimalPad);
        textField.enablesReturnKeyAutomatically = YES;
        textField.returnKeyType = UIReturnKeyDone;
        
        UISegmentedControl *plusMinusControl = [[UISegmentedControl alloc] initWithItems:@[@"-", @"+"]];
        plusMinusControl.momentary = YES;
        [plusMinusControl addTarget:self action:@selector(numberPromptSegmentedControlPressed:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:plusMinusControl];
        [self.view constrainChildToDefaultHorizontalInsets:plusMinusControl];
        [plusMinusControl positionBelowElementWithDefaultMargin:textField];
        self.numberPlusMinusControl = plusMinusControl;
    }
    
    if (self.item.defaultNumberResponse != nil) {
        textField.text = [NSString stringWithFormat:@"%g", [self.item.defaultNumberResponse doubleValue]];
    }
    else if (self.item.defaultStringResponse != nil) {
        textField.text = self.item.defaultStringResponse;
    }
}

- (NSString *)textFieldPlaceholder
{
    if (self.item.itemTypeValue == OHMSurveyItemTypeTextPrompt) {
        return @"Enter text";
    }
    else if(self.item.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
        if (self.item.min != nil && self.item.max != nil) {
            return [NSString stringWithFormat:@"Enter a number between %g and %g", self.item.minValue, self.item.maxValue];
        }
        else if (self.item.min != nil) {
            return [NSString stringWithFormat:@"Enter a number >= %g", self.item.minValue];
        }
        else if (self.item.max != nil) {
            return [NSString stringWithFormat:@"Enter a number <= %g", self.item.maxValue];
        }
        return @"Enter a number";
    }
    
    return @"Enter something";
}

- (BOOL)itemNeedsChoiceTable
{
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
            return YES;
        default:
            return NO;
    }
}

- (void)setupChoiceTable
{
    UITableView *choiceTable = [[UITableView alloc] init];
    choiceTable.delegate = self;
    choiceTable.dataSource = self;
    [choiceTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:choiceTable];
    [self.view constrainChildToDefaultHorizontalInsets:choiceTable];
    [choiceTable positionBelowElementWithDefaultMargin:self.textLabel];
    [choiceTable positionAboveElementWithDefaultMargin:self.toolbar];
}

- (void)cancelButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)skipButtonPressed:(id)sender {
    [self pushNextItemViewController];
}
- (IBAction)nextButtonPressed:(id)sender {
    [self pushNextItemViewController];
}

- (void)pushNextItemViewController
{
    NSInteger nextIndex = self.itemIndex + 1;
    if (nextIndex < [self.surveyResponse.survey.surveyItems count]) {
        OHMSurveyItemViewController *vc = [OHMSurveyItemViewController viewControllerForSurveyResponse:self.surveyResponse atQuestionIndex:self.itemIndex+1];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Number Prompt

- (IBAction)numberPromptSegmentedControlPressed:(id)sender {
    double value = [self.textField.text doubleValue];
    if (value == 0 && self.item.minValue > 0) {
        value = self.item.minValue;
    }
    else {
        value += (self.numberPlusMinusControl.selectedSegmentIndex * 2) - 1;
    }
    if ([self validateNumberValue:value]) {
        self.textField.text = [NSString stringWithFormat:@"%g", value];
        self.nextButton.enabled = YES;
    }
}

- (BOOL)validateNumberValue:(double)value
{
    if (self.item.min != nil && self.item.max != nil) {
        return (value >= self.item.minValue && value <= self.item.maxValue);
    }
    else if (self.item.min != nil) {
        return (value >= self.item.minValue);
    }
    else if (self.item.max != nil) {
        return (value <= self.item.maxValue);
    }
    else {
        return YES;
    }
}

#pragma mark - Choice Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OHMSurveyPromptChoice *choice = self.item.choices[indexPath.row];
    cell.textLabel.text = choice.text;
    if (choice.isDefaultValue && !choice.defaultWasDeselected) {
        choice.isSelected = YES;
    }
    cell.accessoryType = (choice.isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyPromptChoice *choice = self.item.choices[indexPath.row];
    choice.isSelected = !choice.isSelected;
    choice.defaultWasDeselected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if ([self validateTextField]) {
        self.nextButton.enabled = YES;
    }
    else {
        self.nextButton.enabled = NO;
        self.textField.text = nil;
        [self presentValidationMessage];
    }
}

- (void)presentValidationMessage
{
    NSString *message = nil;
    if (self.item.min != nil && self.item.max != nil) {
        message = [NSString stringWithFormat:@"Response must be between %d and %d", [self.item.min intValue], [self.item.max intValue]];
    }
    else if (self.item.min != nil) {
        message = [NSString stringWithFormat:@"Response must be at least %d", [self.item.min intValue]];
    }
    else if (self.item.max != nil) {
        message = [NSString stringWithFormat:@"Response must be no more than %d", [self.item.max intValue]];
    }
    else {
        return;
    }
    
    if (self.item.itemTypeValue == OHMSurveyItemTypeTextPrompt) {
        message = [message stringByAppendingString:@" characters long"];
    }
    
    CGRect messageFrame = CGRectInset(self.textField.frame, kUIViewSmallTextMargin, kUIViewSmallTextMargin);
    UIView *messageView = [OHMUserInterface fixedSizeFramedLabelWithText:message
                                                                    size:messageFrame.size
                                                                    font:[OHMAppConstants textFont]
                                                               alignment:NSTextAlignmentCenter];
    
    [messageView moveOriginToPoint:messageFrame.origin];
    messageView.backgroundColor = [[UIColor redColor] lightColor];
    [self.view insertSubview:messageView belowSubview:self.textField];
    self.validationMessageView = messageView;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         messageView.frame = CGRectOffset(messageView.frame, 0.0, self.textField.frame.size.height + kUIViewSmallTextMargin);
                     }
                     completion:NULL];
}

- (BOOL)validateTextField
{
    if (self.textField.text.length == 0) return NO;
    
    if (self.item.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
        return [self validateNumberValue:[self.textField.text doubleValue]];
    }
    else if (self.item.itemTypeValue == OHMSurveyItemTypeTextPrompt) {
        return [self validateTextValue:self.textField.text];
    }
    
    return YES;
}

- (BOOL)validateTextValue:(NSString *)text
{
    return [self validateNumberValue:[text length]];
}

- (void)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (void)setBackgroundTapEnabled:(BOOL)backgroundTapEnabled
{
    if (backgroundTapEnabled) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        tap.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tap];
        self.backgroundTapGesture = tap;
    }
    else {
        [self.view removeGestureRecognizer:self.backgroundTapGesture];
        self.backgroundTapGesture = nil;
    }
}

@end
