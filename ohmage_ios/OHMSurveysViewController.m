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
#import "OHMSurvey.h"
#import "OHMSurveyDetailViewController.h"

@interface OHMSurveysViewController () <OHMClientDelegate>

@property (nonatomic, strong) OHMClient *client;
@property (nonatomic, strong) NSArray *surveys;

@end

@implementation OHMSurveysViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = @"Ohmage";
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                          target:self action:@selector(refresh)];
        
        self.navigationItem.rightBarButtonItem = refreshButton;
        
//        self.restorationIdentifier = NSStringFromClass([self class]);
//        self.restorationClass = [self class];
        
//        navItem.leftBarButtonItem = self.editButtonItem;
        
//        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//        [nc addObserver:self
//               selector:@selector(updateTableViewForDynamicTypeSize)
//                   name:UIContentSizeCategoryDidChangeNotification
//                 object:nil];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)refresh
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.client = [OHMClient sharedClient];
    self.client.delegate = self;
    
    [self.tableView registerClass:[OHMSurveyTableViewCell class]
           forCellReuseIdentifier:@"OHMSurveyTableViewCell"];
    
    self.tableView.rowHeight = 100;
    
//    self.tableView.restorationIdentifier = @"PQTItemsViewControllerTableView";
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
    
    OHMSurvey *survey = [self.surveys objectAtIndex:indexPath.row];
    
    if (survey.isLoaded) {
        cell.textLabel.text = survey.surveyName;
        cell.detailTextLabel.text = survey.surveyDescription;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    __weak UITableView *weakTableView = self.tableView;
    __weak NSIndexPath *weakIndex = indexPath;
    
    survey.surveyUpdatedBlock = ^{
        [weakTableView reloadRowsAtIndexPaths:@[weakIndex] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = [self.surveys objectAtIndex:indexPath.row];
    OHMSurveyDetailViewController *vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:survey];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OHMSurveyTableViewCell *cell = (OHMSurveyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    return [cell cellHeight];
//}


#pragma mark - Client Delegate

- (void)OHMClientDidUpdate:(OHMClient *)client
{
    self.surveys = [client surveysForOhmlet:[[client ohmlets] anyObject]];
    [self.tableView reloadData];
}

@end
