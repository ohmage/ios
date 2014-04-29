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
#import "OHMUserInterface.h"

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
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.survey = survey;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Survey Detail";
    
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    [self setupHeaderView];
    
    NSLog(@"Survey: %@", self.survey);
}

- (void)setupHeaderView
{
    NSString *nameText = self.survey.surveyName;
    NSString *descriptionText = self.survey.surveyDescription;
    NSString *plural = ([self.survey.surveyItems count] == 1 ? @"Prompt" : @"Prompts");
    NSString *promptCountText = [NSString stringWithFormat:@"%lu %@", (unsigned long)[self.survey.surveyItems count], plural];
    
    CGFloat contentWidth = self.tableView.bounds.size.width - 2 * kUIViewHorizontalMargin;
    CGFloat contentHeight = kUIViewVerticalMargin;
    
    UILabel *nameLabel = [OHMUserInterface headerTitleLabelWithText:nameText width:contentWidth];
    contentHeight += nameLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UILabel *descriptionLabel = [OHMUserInterface headerDescriptionLabelWithText:descriptionText width:contentWidth];
    contentHeight += descriptionLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UILabel *promptCountLabel = [OHMUserInterface headerDetailLabelWithText:promptCountText width:contentWidth];
    contentHeight += promptCountLabel.frame.size.height + kUIViewVerticalMargin;
    
    UIButton *takeSurveyButton = [OHMUserInterface buttonWithTitle:@"Take Survey" target:self action:@selector(takeSurvey:)];
    takeSurveyButton.backgroundColor = [OHMAppConstants colorForRowIndex:self.survey.colorIndex];
    contentHeight += takeSurveyButton.frame.size.height + kUIViewVerticalMargin;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, contentHeight)];
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:descriptionLabel];
    [headerView addSubview:promptCountLabel];
    [headerView addSubview:takeSurveyButton];
    
    [nameLabel centerHorizontallyInView:headerView];
    [descriptionLabel centerHorizontallyInView:headerView];
    [promptCountLabel centerHorizontallyInView:headerView];
    [takeSurveyButton centerHorizontallyInView:headerView];
    
    [nameLabel constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [descriptionLabel positionBelowElement:nameLabel margin:kUIViewSmallTextMargin];
    [promptCountLabel positionBelowElement:descriptionLabel margin:kUIViewSmallTextMargin];
    [takeSurveyButton positionBelowElement:promptCountLabel margin:kUIViewVerticalMargin];
    
    self.tableView.tableHeaderView = headerView;
    self.nameLabel = nameLabel;
    self.descriptionLabel = descriptionLabel;
    self.promptCountLabel = promptCountLabel;
    self.takeSurveyButton = takeSurveyButton;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;// MAX([self.survey.surveyResponses count], 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = @"No responses logged yet.";
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OHMSurvey *survey = self.surveys[indexPath.row];
//    OHMSurveyResponse *newResponse = [[OHMClient sharedClient] buildResponseForSurvey:survey];
//    OHMSurveyItemViewController *vc = [OHMSurveyItemViewController viewControllerForSurveyResponse:newResponse atQuestionIndex:0];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    OHMSurvey *survey = [self.surveys objectAtIndex:indexPath.row];
//    OHMSurveyDetailViewController *vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:survey];
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OHMSurvey *survey = self.surveys[indexPath.row];
//    return [OHMUserInterface heightForSubtitleCellWithTitle:survey.surveyName
//                                                   subtitle:survey.surveyDescription
//                                              accessoryType:UITableViewCellAccessoryDetailDisclosureButton
//                                              fromTableView:tableView];
//}


@end
