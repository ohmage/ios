//
//  OHMOhmletViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/2/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMOhmletViewController.h"
#import "OHMOhmage.h"
#import "OHMSurvey.h"

@interface OHMOhmletViewController () <OHMAccountManagerDelegate>

@property (nonatomic, strong) OHMOhmage *account;

@end

@implementation OHMOhmletViewController

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
    
    self.account = [OHMOhmage sharedManager];
    self.account.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
//    self.tableView.restorationIdentifier = @"PQTItemsViewControllerTableView";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ohmlet surveyCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *surveys = [self.ohmlet allSurveys];
    OHMSurvey *survey = [surveys objectAtIndex:indexPath.row];
    cell.textLabel.text = survey.surveyName;
    
    return cell;
}

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


#pragma mark - User Delegate

- (void)OHMUser:(OHMUser *)user didRefreshOhmlet:(OHMOhmlet *)ohmlet
{
    self.ohmlet = ohmlet;
    self.ohmlet.delegate = self;
    [self.tableView reloadData];
}


#pragma mark - Ohmlet Delegate

- (void)OHMOhmletDidRefreshSurveys:(OHMOhmlet *)ohmlet
{
    [self.tableView reloadData];
}

@end
