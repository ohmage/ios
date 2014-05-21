//
//  OHMSurveyDetailViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/8/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyDetailViewController.h"
#import "OHMSurveyItemViewController.h"
#import "OHMReminderViewController.h"
#import "OHMSurveyResponseViewController.h"
#import "OHMSurvey.h"
#import "OHMSurveyResponse.h"
#import "OHMReminder.h"

static const NSInteger kRemindersSectionIndex = 0;
static const NSInteger kSurveyResponsesSectionIndex = 1;

@interface OHMSurveyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *takeSurveyButton;
@property (nonatomic, strong) OHMSurvey *survey;

@property (nonatomic, strong) NSFetchedResultsController *fetchedSurveyResponsesController;
@property (nonatomic, strong) NSFetchedResultsController *fetchedRemindersController;

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
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    [self setupHeaderView];
    
    NSPredicate *remindersPredicate = [NSPredicate predicateWithFormat:@"survey == %@", self.survey];
    self.fetchedRemindersController = [[OHMClient sharedClient] fetchedResultsControllerWithEntityName:[OHMReminder entityName] sortKey:@"isLocationReminder" predicate:remindersPredicate sectionNameKeyPath:nil cacheName:nil];
    
    NSPredicate *sureveyResultsPredicate = [NSPredicate predicateWithFormat:@"survey == %@", self.survey];
    self.fetchedSurveyResponsesController = [[OHMClient sharedClient] fetchedResultsControllerWithEntityName:[OHMSurveyResponse entityName] sortKey:@"timestamp" predicate:sureveyResultsPredicate sectionNameKeyPath:nil cacheName:nil];
    
    NSLog(@"Survey: %@, ID: %@, version: %d", self.survey.surveyName, self.survey.ohmID, self.survey.surveyVersionValue);
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
    
    UIButton *takeSurveyButton = [OHMUserInterface buttonWithTitle:@"Take Survey"
                                                             color:[OHMAppConstants colorForSurveyIndex:self.survey.indexValue]
                                                            target:self
                                                            action:@selector(takeSurvey:)
                                                          maxWidth:contentWidth];
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
    self.navigationController.navigationBar.barTintColor = [OHMAppConstants colorForSurveyIndex:self.survey.indexValue];
    
    [self.fetchedRemindersController performFetch:nil];
    [self.fetchedSurveyResponsesController performFetch:nil];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeSurvey:(id)sender {
    
    OHMSurveyResponse *newResponse = [[OHMClient sharedClient] buildResponseForSurvey:self.survey];
    OHMSurveyItemViewController *vc = [[OHMSurveyItemViewController alloc] initWithSurveyResponse:newResponse atQuestionIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)doneButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kRemindersSectionIndex:
            return [[self.fetchedRemindersController fetchedObjects] count] + 1;
        case kSurveyResponsesSectionIndex:
            return MAX([[self.fetchedSurveyResponsesController fetchedObjects] count], 1);
        default:
            return 0;
    }
    
}

//- (void)configureReminderCell:(UITableViewCell *)cell forRow:(NSInteger)row
//{
//    if (row == 0) {
//        cell.textLabel.text = @"Add reminder";
//        cell.detailTextLabel.text = nil;
//    }
//    else if ([[self.fetchedRemindersController fetchedObjects] count] >= row - 1) {
//        OHMReminder *reminder = [self.fetchedRemindersController objectAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
//        cell.textLabel.text = [reminder labelText];
//        cell.detailTextLabel.text = [reminder repeatLabelText];
//    }
//}

- (void)configureSurveyResponseCell:(UITableViewCell *)cell forRow:(NSInteger)row
{
    if ([[self.fetchedSurveyResponsesController fetchedObjects] count]) {
        OHMSurveyResponse *response = [self.fetchedSurveyResponsesController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        cell.textLabel.text = [OHMUserInterface formattedDate:response.timestamp];
    }
    else {
        cell.textLabel.text = @"No responses logged yet.";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case kRemindersSectionIndex:
            if (indexPath.row == 0) {
                cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
                cell.textLabel.text = @"Add reminder";
            }
            else {
                OHMReminder *reminder = [self.fetchedRemindersController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:0]];
                cell = [OHMUserInterface cellWithSwitchFromTableView:tableView setupBlock:^(UISwitch *sw) {
                    sw.on = reminder.enabledValue;
                    [sw addTarget:reminder action:@selector(toggleEnabled) forControlEvents:UIControlEventValueChanged];
                }];
                cell.textLabel.text = [reminder labelText];
                cell.detailTextLabel.text = [reminder detailLabelText];
            }
            break;
        case kSurveyResponsesSectionIndex:
            cell = [OHMUserInterface cellWithDefaultStyleFromTableView:tableView];
            [self configureSurveyResponseCell:cell forRow:indexPath.row];
            break;
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kRemindersSectionIndex:
            return @"Reminders";
        case kSurveyResponsesSectionIndex:
            return @"Survey Responses";
        default:
            return nil;
            break;
    }
}

- (void)didSelectReminderCellAtRow:(NSInteger)row
{
    OHMReminder *reminder = nil;
    if (row == 0) {
        reminder = [[OHMClient sharedClient] buildNewReminderForSurvey:self.survey];
    }
    else if ([[self.fetchedRemindersController fetchedObjects] count] >= row) {
        reminder = [self.fetchedRemindersController objectAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
    }
    
    OHMReminderViewController *vc = [[OHMReminderViewController alloc] initWithReminder:reminder];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectSurveyResponseCellAtRow:(NSInteger)row
{
    OHMSurveyResponse *response = [self.fetchedSurveyResponsesController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    OHMSurveyResponseViewController *vc = [[OHMSurveyResponseViewController alloc] initWithSurveyResponse:response];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kRemindersSectionIndex:
            [self didSelectReminderCellAtRow:indexPath.row];
            break;
        case kSurveyResponsesSectionIndex:
            [self didSelectSurveyResponseCellAtRow:indexPath.row];
            break;
        default:
            break;
    }
}
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
