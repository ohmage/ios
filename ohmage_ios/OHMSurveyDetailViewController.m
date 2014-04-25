//
//  OHMSurveyDetailViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyDetailViewController.h"
#import "OHMSurvey.h"
#import "OHMSurveyResponse.h"
#import "OHMSurveyItemViewController.h"

@interface OHMSurveyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *takeSurveyButton;
@property (nonatomic, strong) OHMSurvey *survey;

@end

@implementation OHMSurveyDetailViewController

- (id)initWithSurvey:(OHMSurvey *)survey
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.survey = survey;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Survey Detail";
    
    self.takeSurveyButton.backgroundColor = [OHMAppConstants colorForRowIndex:self.survey.colorIndex];
    
    self.nameLabel.text = self.survey.surveyName;
    self.descriptionLabel.text = self.survey.surveyDescription;
    self.promptCountLabel.text = [NSString stringWithFormat:@"%lu Prompts", (unsigned long)[self.survey.surveyItems count]];
    
    NSLog(@"Survey: %@", self.survey.description);
    
//    self.view.backgroundColor = [OHMAppConstants lightColorForRowIndex:self.survey.colorIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    self.navigationController.navigationBar.barTintColor = [OHMAppConstants colorForRowIndex:self.survey.colorIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeSurvey:(id)sender {
    
    OHMSurveyResponse *newResponse = [[OHMClient sharedClient] buildResponseForSurvey:self.survey];
    OHMSurveyItemViewController *vc = [OHMSurveyItemViewController viewControllerForSurveyResponse:newResponse atQuestionIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
