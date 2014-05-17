//
//  OHMSurveyItemViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyItemViewController.h"
#import "OHMSurveyResponseViewController.h"
#import "OHMSurveyDetailViewController.h"
#import "OHMSurvey.h"
#import "OHMSurveyResponse.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMUserInterface.h"
#import "OHMSurveyPromptChoice.h"
#import "OHMAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>

@interface OHMSurveyItemViewController () <UITextFieldDelegate,
UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, OHMAudioRecorderDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *actionButton;

@property (nonatomic) BOOL backgroundTapEnabled;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapGesture;
@property (nonatomic, strong) UIView *validationMessageView;
@property (nonatomic) NSInteger selectedCount;

@property (nonatomic, strong) UISegmentedControl *numberPlusMinusControl;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImagePickerController *videoPicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIDatePicker *timePicker;

@property (nonatomic, strong) OHMAudioRecorder *audioRecorder;
@property (nonatomic, strong) UIButton *recordAudioButton;
@property (nonatomic, strong) UIButton *playAudioButton;

@property (nonatomic, strong) OHMSurveyItem *item;
@property (nonatomic, strong) OHMSurveyPromptResponse *promptResponse;

@end

@implementation OHMSurveyItemViewController


- (id)initWithSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.surveyResponse = response;
        if (![response shouldShowItemAtIndex:index]) {
            
        }
        self.itemIndex = index;
        self.promptResponse = self.surveyResponse.promptResponses[self.itemIndex];
        self.item = self.promptResponse.surveyItem;
//        NSLog(@"controller for itemID: %@", self.item.ohmID);
        
    }
    return self;
}

- (void)loadView
{
    [self basicSetup];
    
    if ([self itemNeedsTextField]) {
        [self setupTextField];
    }
    
    if ([self itemNeedsChoiceTable]) {
        [self setupChoiceTable];
    }
    
    if ([self itemNeedsActionButton]) {
        [self setupActionButton];
    }
    
    if ([self itemNeedsDatePicker]) {
        [self setupDateTimePickers];
    }
    
    if ([self itemNeedsAudioRecorder]) {
        [self setupAudioRecorder];
    }
    
    if ([self itemNeedsImageView]) {
        self.imageView.image = self.promptResponse.imageValue;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"view did load with itemID: %@", self.item.description);
    
    id<UILayoutSupport> topGuide = self.topLayoutGuide;
    id<UILayoutSupport> bottomGuide = self.bottomLayoutGuide;
    [self.textLabel positionBelowElement:topGuide margin:2 * kUIViewVerticalMargin];
    [self.toolbar positionAboveElementWithDefaultMargin:bottomGuide];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %ld", self.itemIndex + 1, (unsigned long)[self.surveyResponse.survey.surveyItems count]];
    
    self.textLabel.text = self.item.text;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelSurveyButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    UIColor *color = [OHMAppConstants colorForSurveyIndex:self.surveyResponse.survey.indexValue];
    self.navigationController.navigationBar.barTintColor = color;
    self.toolbar.barTintColor = color;
    self.toolbar.tintColor = [UIColor whiteColor];
    
    [self updateNextButtonEnabledState];
    
    if (self.presentingViewController != nil) {
        [self setupForModalPresentation];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // in case item originally failed condition
    // but this time passed condiction, clear notDisplayed flag
    self.promptResponse.notDisplayedValue = NO;
}

- (void)setupForModalPresentation
{
    if (self.itemIndex > 0 && [[self.navigationController.viewControllers firstObject] isEqual:self]) {
        OHMSurveyItemViewController *previous = [[OHMSurveyItemViewController alloc] initWithSurveyResponse:self.surveyResponse atQuestionIndex:self.itemIndex - 1];
        self.navigationController.viewControllers = [@[previous] arrayByAddingObjectsFromArray:self.navigationController.viewControllers];
    }
    
    self.navigationItem.leftBarButtonItem = self.doneButton;
    self.nextButton.title = @"Next";
}

- (void)updateNextButtonEnabledState
{
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
            self.nextButton.enabled = [self validateChoices];
            break;
        case OHMSurveyItemTypeNumberPrompt:
        case OHMSurveyItemTypeTextPrompt:
            self.nextButton.enabled = [self validateTextField];
            break;
        case OHMSurveyItemTypeMessage:
        default:
            self.nextButton.enabled = YES;
            break;
    }
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

- (BOOL)itemNeedsActionButton
{
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
        case OHMSurveyItemTypeVideoPrompt:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)itemNeedsDatePicker
{
    return (self.item.itemTypeValue == OHMSurveyItemTypeTimestampPrompt);
}

- (BOOL)itemNeedsAudioRecorder
{
    return (self.item.itemTypeValue == OHMSurveyItemTypeAudioPrompt);
}

- (BOOL)itemNeedsImageView
{
    if (self.item.itemTypeValue == OHMSurveyItemTypeImagePrompt || self.item.itemTypeValue == OHMSurveyItemTypeVideoPrompt) {
        return self.promptResponse.imageValue != nil;
    }
    else {
        return NO;
    }
}


#pragma mark - Setup

- (void)basicSetup
{
    UIView * view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    [barItems addObject:nextButton];
    self.nextButton = nextButton;
    
    toolbar.items = barItems;
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
    
    if (self.promptResponse.numberValue != nil) {
        textField.text = [NSString stringWithFormat:@"%g", self.promptResponse.numberValueValue];
    }
    else if (self.promptResponse.stringValue != nil) {
        textField.text = self.promptResponse.stringValue;
    }
    else if (self.item.defaultNumberResponse != nil) {
        textField.text = [NSString stringWithFormat:@"%g", self.item.defaultNumberResponseValue];
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
        return @"Enter a number";
    }
    
    return @"Enter something";
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

- (NSString *)actionButtonTitleText
{
    
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
            return @"Take Picture";
        case OHMSurveyItemTypeAudioPrompt:
            return @"Record Audio";
        case OHMSurveyItemTypeVideoPrompt:
            return @"Record Video";
        default:
            return nil;
    }
}

- (void)setupActionButton
{
    
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kUIViewHorizontalMargin;
    UIButton *button = [OHMUserInterface buttonWithTitle:[self actionButtonTitleText]
                                                   color:[OHMAppConstants colorForSurveyIndex:self.surveyResponse.survey.indexValue]
                                                  target:self
                                                  action:@selector(actionButtonPressed:)
                                                maxWidth:buttonWidth];
    [self.view addSubview:button];
    [button centerHorizontallyInView:self.view];
    [button positionBelowElementWithDefaultMargin:self.textLabel];
    self.actionButton = button;
}

- (void)setupDateTimePickers
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    [datePicker positionBelowElement:self.textLabel margin:0];
    [datePicker centerHorizontallyInView:self.view];
    
    UIDatePicker *timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:timePicker];
    [timePicker positionBelowElement:datePicker margin:-35];
    [timePicker centerHorizontallyInView:self.view];
    [self.view sendSubviewToBack:timePicker];
    
    self.datePicker = datePicker;
    self.timePicker = timePicker;
}

- (void)setupAudioRecorder
{
    CGFloat buttonWidth = (self.view.bounds.size.width - 3.0 * kUIViewHorizontalMargin) / 2.0;
    UIButton *recordButton = [OHMUserInterface buttonWithTitle:@"Record"
                                                   color:[OHMAppConstants colorForSurveyIndex:self.surveyResponse.survey.indexValue]
                                                  target:self
                                                  action:@selector(recordAudioButtonPressed:)
                                              fixedWidth:buttonWidth];
    UIButton *playButton = [OHMUserInterface buttonWithTitle:@"Play"
                                                       color:[OHMAppConstants colorForSurveyIndex:self.surveyResponse.survey.indexValue]
                                                      target:self
                                                      action:@selector(playAudioButtonPressed:)
                                                  fixedWidth:buttonWidth];
    
    [self.view addSubview:recordButton];
    [self.view addSubview:playButton];
    
    [recordButton positionBelowElementWithDefaultMargin:self.textLabel];
    [playButton positionBelowElementWithDefaultMargin:self.textLabel];
    [self.view layoutChildrenHorizontallyWithDefaultMargins:@[recordButton, playButton]];
    
    self.recordAudioButton = recordButton;
    self.playAudioButton = playButton;
    
    self.audioRecorder = [[OHMAudioRecorder alloc] initWithDelegate:self];
    if (self.item.maxDuration) {
        self.audioRecorder.maxDuration = self.item.maxDurationTimeInterval;
    }
    
    [self updateAudioButtonStates];
}


#pragma mark - Interaction

- (void)doneButtonPressed:(id)sender
{
    [self cancelModalPresentationButtonPressed:sender];
}

- (void)cancelSurveyButtonPressed:(id)sender
{
    [[OHMClient sharedClient] deleteObject:self.surveyResponse];
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:1];
    if ([vc isMemberOfClass:[OHMSurveyDetailViewController class]]) {
        [self.navigationController popToViewController:vc animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)skipButtonPressed:(id)sender
{
    self.promptResponse.skippedValue = YES;
    [self.promptResponse clearValues];
    [self pushNextItemViewController];
}

- (void)nextButtonPressed:(id)sender
{
    self.promptResponse.skippedValue = NO;
    if (self.item.itemTypeValue == OHMSurveyItemTypeTimestampPrompt) {
        [self recordDateTime];
    }
    [self pushNextItemViewController];
}

- (void)actionButtonPressed:(id)sender
{
    switch (self.item.itemTypeValue) {
        case OHMSurveyItemTypeImagePrompt:
            [self takePicture];
            break;
        case OHMSurveyItemTypeVideoPrompt:
            [self recordVideo];
            break;
        default:
            break;
    }
}

- (void)pushNextItemViewController
{
    NSInteger nextIndex = self.itemIndex + 1;
    
    while (nextIndex < self.surveyResponse.promptResponses.count && ![self.surveyResponse shouldShowItemAtIndex:nextIndex]) {
        ((OHMSurveyPromptResponse* )self.surveyResponse.promptResponses[nextIndex]).notDisplayedValue = YES;
        nextIndex++;
    }
    if (nextIndex < [self.surveyResponse.survey.surveyItems count]) {
        OHMSurveyItemViewController *vc = [[OHMSurveyItemViewController alloc] initWithSurveyResponse:self.surveyResponse atQuestionIndex:nextIndex];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        OHMSurveyResponseViewController *vc = [[OHMSurveyResponseViewController alloc] initWithSurveyResponse:self.surveyResponse];
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
        [self setResponseValueFromTextField];
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
    cell.accessoryType = ([self.promptResponse.selectedChoices containsObject:choice] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyPromptChoice *choice = self.item.choices[indexPath.row];
    if ([self.promptResponse.selectedChoices containsObject:choice]) {
        [self.promptResponse removeSelectedChoicesObject:choice];
    }
    else {
        if (self.item.itemTypeValue == OHMSurveyItemTypeNumberSingleChoicePrompt
            || self.item.itemTypeValue == OHMSurveyItemTypeStringSingleChoicePrompt) {
            [self.promptResponse.selectedChoicesSet removeAllObjects];
        }
        [self.promptResponse addSelectedChoicesObject:choice];
    }
    self.nextButton.enabled = [self validateChoices];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)validateChoices
{
    NSInteger choiceCount = [self.promptResponse.selectedChoices count];
    if (self.item.minChoices != nil && self.item.maxChoices != nil) {
        return (choiceCount >= self.item.minChoicesValue && choiceCount <= self.item.maxChoicesValue);
    }
    else if (self.item.minChoices != nil) {
        return (choiceCount >= self.item.minChoicesValue);
    }
    else if (self.item.maxChoices != nil) {
        return (choiceCount <= self.item.maxChoicesValue);
    }
    else {
        return (choiceCount > 0);
    }
}

#pragma mark - TextField Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // call to "super"
    [self.viewControllerComposite textFieldDidEndEditing:textField];
    
    if ([self validateTextField]) {
        [self setResponseValueFromTextField];
        self.nextButton.enabled = YES;
    }
    else {
        self.nextButton.enabled = NO;
        self.textField.text = nil;
        [self presentValidationMessage];
    }
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

- (void)setResponseValueFromTextField
{
    if (self.item.itemTypeValue == OHMSurveyItemTypeNumberPrompt) {
        self.promptResponse.numberValueValue = (self.item.wholeNumbersOnlyValue ? [self.textField.text integerValue]
                                                : [self.textField.text doubleValue]);
    }
    else if (self.item.itemTypeValue == OHMSurveyItemTypeTextPrompt) {
        self.promptResponse.stringValue = self.textField.text;
    }
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
    
    UIView *presenter = self.numberPlusMinusControl ? self.numberPlusMinusControl : self.textField;
    CGRect messageFrame = CGRectInset(presenter.frame, kUIViewSmallTextMargin, kUIViewSmallTextMargin);
    UIView *messageView = [OHMUserInterface fixedSizeFramedLabelWithText:message
                                                                    size:messageFrame.size
                                                                    font:[OHMAppConstants textFont]
                                                               alignment:NSTextAlignmentCenter];
    
    [messageView moveOriginToPoint:messageFrame.origin];
    messageView.backgroundColor = [OHMAppConstants colorForSurveyIndex:self.surveyResponse.survey.indexValue];
    [self.view insertSubview:messageView belowSubview:presenter];
    self.validationMessageView = messageView;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         messageView.frame = CGRectOffset(messageView.frame, 0.0, presenter.frame.size.height + kUIViewSmallTextMargin);
                     }
                     completion:NULL];
}

#pragma - mark Image Prompt

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        [imageView positionBelowElementWithDefaultMargin:self.actionButton];
        [imageView positionAboveElementWithDefaultMargin:self.toolbar];
        [self.view constrainChildToDefaultHorizontalInsets:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (void)takePicture
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    self.imagePicker = imagePicker;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (UIImage *)thumbnailFromVideoURL:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([picker isEqual:self.imagePicker]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.promptResponse.imageValue = image;
        self.imageView.image = image;
    }
    else if ([picker isEqual:self.videoPicker]) {
        NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
        if (mediaURL) {
            self.promptResponse.videoURL = mediaURL;
            self.promptResponse.imageValue = [self thumbnailFromVideoURL:mediaURL];
            self.imageView.image = self.promptResponse.imageValue;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - mark Video Prompt

- (void)recordVideo
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        NSArray *availableTypes = [UIImagePickerController
                                   availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([availableTypes containsObject:(__bridge NSString *)kUTTypeMovie]) {
            [imagePicker setMediaTypes:@[(__bridge NSString *)kUTTypeMovie]];
            if (self.promptResponse.surveyItem.maxDuration != nil) {
                imagePicker.videoMaximumDuration = self.promptResponse.surveyItem.maxDurationValue;
            }
        }
        else {
            return;
        }
    } else {
        return;
    }
    
    imagePicker.delegate = self;
    self.videoPicker = imagePicker;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma - mark Audio Prompt

- (void)updateAudioButtonStates
{
    NSString *recordButtonTitle = self.audioRecorder.isRecording ? @"Stop" : @"Record";
    NSString *playButtonTitle = self.audioRecorder.isPlaying ? @"Stop" : @"Play";
    [self.recordAudioButton setTitle:recordButtonTitle forState:UIControlStateNormal];
    [self.playAudioButton setTitle:playButtonTitle forState:UIControlStateNormal];
    
    self.recordAudioButton.enabled = (self.audioRecorder.hasMicrophoneAccess && !self.audioRecorder.isPlaying);
    self.playAudioButton.enabled = ( !self.audioRecorder.isRecording && (self.promptResponse.audioURL != nil) );
}

- (void)recordAudioButtonPressed:(id)sender
{
    if (self.audioRecorder.isRecording) {
        [self.audioRecorder stopRecording];
    }
    else if ([self.audioRecorder startRecording]) {
        [self updateAudioButtonStates];
    }
}

- (void)playAudioButtonPressed:(id)sender
{
    if (self.audioRecorder.isPlaying) {
        [self.audioRecorder stopPlaying];
    }
    else if (self.promptResponse.audioURL != nil) {
        [self.audioRecorder playFileAtURL:self.promptResponse.audioURL];
    }
    [self updateAudioButtonStates];
}

- (void)OHMAudioRecorder:(OHMAudioRecorder *)recorder didFinishRecordingToURL:(NSURL *)recordingURL
{
    self.promptResponse.audioURL = recordingURL;
    [self updateAudioButtonStates];
}

- (void)OHMAudioRecorderDidFinishPlaying:(OHMAudioRecorder *)recorder
{
    [self updateAudioButtonStates];
}

- (void)OHMAudioRecorderFailed:(OHMAudioRecorder *)recorder
{
    [self updateAudioButtonStates];
}

- (void)OHMAudioRecorderMicrophoneAccessDenied:(OHMAudioRecorder *)recorder
{
    [self updateAudioButtonStates];
}


#pragma - mark Timestamp Prompt

- (void)recordDateTime
{
    self.promptResponse.timestampValue = [self combineDate:self.datePicker.date withTime:self.timePicker.date];
    NSLog(@"recorded dateTime: %@", self.promptResponse.timestampValue);
}

- (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime fromDate:time];
    
    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
    
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];
    
    return combDate;
}

@end
