//
//  OHMOhmletViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/2/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveysViewController.h"
#import "OHMSurveyTableViewCell.h"
#import "OHMOhmage.h"
#import "OHMSurvey.h"

@interface OHMSurveysViewController () <OHMOhmageDelegate>

@property (nonatomic, strong) OHMOhmage *ohmage;
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
    
    self.ohmage = [OHMOhmage sharedOhmage];
    self.ohmage.delegate = self;
    
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
    return [self.ohmage surveyCount];
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
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OHMSurveyTableViewCell *cell = (OHMSurveyTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    return [cell cellHeight];
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Ohmage Delegate

- (void)OHMOhmage:(OHMOhmage *)ohmage didRefreshSurveys:(NSArray *)surveys
{
    self.surveys = surveys;
    [self.tableView reloadData];
}

@end
