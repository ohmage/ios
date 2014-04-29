//
//  OHMSurveyCompleteViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/28/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyCompleteViewController.h"
#import "OHMSurveyDetailViewController.h"
#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMUserInterface.h"
#import "OHMMediaStore.h"

@interface OHMSurveyCompleteViewController ()

@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation OHMSurveyCompleteViewController

- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)response
{
    self = [super init];
    if (self) {
        self.surveyResponse = response;
        self.itemIndex = [response.survey.surveyItems count]; // to enable back button
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Survey Complete";
    
    CGFloat buttonWidth = self.view.bounds.size.width - 2 * kUIViewHorizontalMargin;
    UIButton *button = [OHMUserInterface buttonWithTitle:@"Submit" target:self action:@selector(submitButtonPressed:) maxWidth:buttonWidth];
    button.backgroundColor = [OHMAppConstants colorForRowIndex:self.surveyResponse.survey.colorIndex];
    [self.view addSubview:button];
    [button centerHorizontallyInView:self.view];
    [button positionBelowElementWithDefaultMargin:self.topLayoutGuide];
    self.submitButton = button;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitButtonPressed:(id)sender
{
    self.surveyResponse.timestamp = [NSDate date];
    [[OHMClient sharedClient] saveClientState];
    OHMSurveyDetailViewController *vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:self.surveyResponse.survey];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:vc
                                                                      action:@selector(popToNavigationRootAnimated)];
    vc.navigationItem.leftBarButtonItem = doneButtonItem;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
