//
//  OHMOhmletViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/2/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveysViewController.h"
#import "OHMSurveyTableViewCell.h"
#import "OHMClient.h"
#import "OHMOhmlet.h"
#import "OHMSurvey.h"
#import "OHMSurveyDetailViewController.h"
#import "OHMSurveyItemViewController.h"
#import "OHMUserInterface.h"

@interface OHMSurveysViewController () <OHMClientDelegate>

@property (nonatomic, strong) OHMClient *client;
@property (nonatomic, strong) OHMOhmlet *ohmlet;
@property (nonatomic, strong) NSArray *surveys;
@property (nonatomic) NSInteger ohmletIndex;

@end

@implementation OHMSurveysViewController

- (instancetype)initWithOhmletIndex:(NSInteger)ohmletIndex
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.ohmletIndex = ohmletIndex;
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)refresh
{
    [self setupHeader];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:nil
                                                                      action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    self.navigationItem.title = @"Ohmage";
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [OHMAppConstants lightOhmageColor];
    self.tableView.backgroundColor = [OHMAppConstants lightOhmageColor];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(0, 0, 35, 35);
    [customButton setImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
    UIBarButtonItem *ohmButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.navigationItem.leftBarButtonItem = ohmButton;
    
    UIButton *customHelpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customHelpButton.frame = CGRectMake(0, 0, 35, 35);
    [customHelpButton setImage:[UIImage imageNamed:@"dash_helpblue"] forState:UIControlStateNormal];
    UIBarButtonItem *helpButton = [[UIBarButtonItem alloc] initWithCustomView:customHelpButton];
    self.navigationItem.rightBarButtonItem = helpButton;
    
    
//    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
//                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
//                                      target:self action:@selector(refresh)];
//    
//    self.navigationItem.rightBarButtonItem = refreshButton;
    
    self.client = [OHMClient sharedClient];
    self.client.delegate = self;
    
    [self.tableView registerClass:[OHMSurveyTableViewCell class]
           forCellReuseIdentifier:@"OHMSurveyTableViewCell"];
    
//    self.tableView.rowHeight = 100;
    
    if ([[self.client ohmlets] count] > self.ohmletIndex) {
        self.ohmlet = [self.client ohmlets][self.ohmletIndex];
    }
    
    [self setupHeader];
    
//    self.tableView.restorationIdentifier = @"PQTItemsViewControllerTableView";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
    self.navigationController.navigationBar.barTintColor = [OHMAppConstants ohmageColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"did appear nav bounds: %@", NSStringFromCGRect(self.navigationController.navigationBar.bounds));
}

- (void)setupTitleView
{
    NSLog(@"nav bounds: %@", NSStringFromCGRect(self.navigationController.navigationBar.bounds));
    CGRect titleFrame = self.navigationController.navigationBar.bounds;
    UIView *titleView = [[UIView alloc] initWithFrame:titleFrame];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    [iconView constrainEqualWidthAndHeight];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Ohmage";
    
    [titleView addSubview:iconView];
    [titleView addSubview:titleLabel];
    
    [titleLabel centerHorizontallyInView:titleView];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(4, 0, 4, 0);
    [titleView  constrainChild:iconView toVerticalInsets:insets];
    [titleView  constrainChild:titleLabel toVerticalInsets:insets];
    
    [titleView addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[iconView]-[titleLabel]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(iconView, titleLabel)]];
    
    self.navigationItem.titleView = titleView;
}

- (void)setupHeader
{
    return;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIView *contentView = [[UIView alloc] init];
    [headerView addSubview:contentView];
    [headerView constrainChildToDefaultInsets:contentView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont boldSystemFontOfSize:14];
    nameLabel.numberOfLines = 0;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    if (self.ohmlet) {
        NSString *name = self.ohmlet.ohmletName ? self.ohmlet.ohmletName : self.ohmlet.ohmID;
        nameLabel.text = [@"Ohmlet: " stringByAppendingString:name];
    }
    else {
        nameLabel.text = @"Loading Data";
    }
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = self.ohmlet.ohmletDescription;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = MIN([self.client.ohmlets count], 1);
    
    [contentView addSubview:nameLabel];
    [contentView addSubview:descriptionLabel];
    [contentView addSubview:pageControl];
    
    [contentView constrainChildToDefaultHorizontalInsets:nameLabel];
    [contentView constrainChildToDefaultHorizontalInsets:descriptionLabel];
    [contentView constrainChildToDefaultHorizontalInsets:pageControl];
    
    [nameLabel constrainToTopInParentWithMargin:kUIViewVerticalMargin];
    [descriptionLabel positionBelowView:nameLabel margin:kUIViewVerticalMargin];
    [pageControl positionBelowView:descriptionLabel margin:kUIViewVerticalMargin];
    [pageControl constrainToBottomInParentWithMargin:kUIViewVerticalMargin];
    
    [headerView sizeToFit];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.surveys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OHMSurveyTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OHMSurvey *survey = [self.surveys objectAtIndex:indexPath.row];
    
    if (survey.isLoaded) {
        cell.textLabel.text = survey.surveyName;
        cell.detailTextLabel.text = survey.surveyDescription;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundColor = [OHMAppConstants lightColorForRowIndex:indexPath.row];
        cell.tintColor = [UIColor darkTextColor];
        survey.colorIndex = indexPath.row;
//        CGFloat height = [OHMUserInterface heightForSubtitleCellWithTitle:cell.textLabel.text subtitle:cell.detailTextLabel.text accessoryType:cell.accessoryType];
//        NSLog(@"height for cell %ld: %f", indexPath.row, height);
    }
    
    __weak UITableView *weakTableView = self.tableView;
    __weak NSIndexPath *weakIndex = indexPath;
    
    survey.surveyUpdatedBlock = ^{
        [weakTableView reloadRowsAtIndexPaths:@[weakIndex] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"content bounds: %@, label frame: %@, height: %f", NSStringFromCGRect(cell.contentView.bounds), NSStringFromCGRect(cell.textLabel.frame), [OHMUserInterface heightForSubtitleCellWithTitle:cell.textLabel.text subtitle:cell.detailTextLabel.text accessoryType:cell.accessoryType fromTableView:tableView]);
    OHMSurvey *survey = self.surveys[indexPath.row];
    OHMSurveyResponse *newResponse = [[OHMClient sharedClient] buildResponseForSurvey:survey];
    OHMSurveyItemViewController *vc = [OHMSurveyItemViewController viewControllerForSurveyResponse:newResponse atQuestionIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = [self.surveys objectAtIndex:indexPath.row];
    OHMSurveyDetailViewController *vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:survey];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = self.surveys[indexPath.row];
    return [OHMUserInterface heightForSubtitleCellWithTitle:survey.surveyName
                                                   subtitle:survey.surveyDescription
                                              accessoryType:UITableViewCellAccessoryDetailDisclosureButton
                                              fromTableView:tableView];
}


#pragma mark - Client Delegate

- (void)OHMClientDidUpdate:(OHMClient *)client
{
    if (self.ohmletIndex >= [client.ohmlets count]) {
        self.ohmletIndex = [client.ohmlets count] - 1;
    }
    if (self.ohmletIndex >= 0) {
        self.ohmlet = [client ohmlets][self.ohmletIndex];
        self.surveys = [client surveysForOhmlet:self.ohmlet];
        [self setupHeader];
        [self.tableView reloadData];
    }
}

@end
