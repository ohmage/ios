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

@interface OHMSurveyItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (nonatomic, strong) OHMSurveyItem *item;

@end

@implementation OHMSurveyItemViewController

+ (instancetype)viewControllerForSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index
{
    return [[OHMSurveyItemViewController alloc] initWithSurveyResponse:response atQuestionIndex:index];
}

- (id)initWithSurveyResponse:(OHMSurveyResponse *)response atQuestionIndex:(NSInteger)index
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.surveyResponse = response;
        self.itemIndex = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld of %ld", self.itemIndex + 1, [self.surveyResponse.survey.surveyItems count]];
    
    self.item = self.surveyResponse.survey.surveyItems[self.itemIndex];
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

@end
