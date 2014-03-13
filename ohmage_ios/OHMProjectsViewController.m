//
//  OHMProjectsViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMProjectsViewController.h"
#import "OHMProjectDetailViewController.h"
#import "OHMProjectStore.h"
#import "OHMProject.h"

static NSString * const kProjectsTableCellIdentifier = @"ProjectsTableCell";

@interface OHMProjectsViewController ()

@end

@implementation OHMProjectsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"My Projects";
        
        UIBarButtonItem *addProjectButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                             action:@selector(addProject:)];
        
        UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                             target:self
                                             action:@selector(refreshList:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItems = @[addProjectButton, refreshButton];
        
        [[OHMProjectStore sharedStore] createProject];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[OHMProjectStore sharedStore] allProjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an instance of UITableViewCell, with default appearance
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProjectsTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kProjectsTableCellIdentifier];
    }
    
    OHMProject *project = [[OHMProjectStore sharedStore] allProjects][indexPath.row];
    
    cell.textLabel.text = project.name;
    cell.detailTextLabel.text = project.urn;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *projects = [[OHMProjectStore sharedStore] allProjects];
    OHMProject *selectedProject = projects[indexPath.row];
    
    OHMProjectDetailViewController *detailViewController = [[OHMProjectDetailViewController alloc] initWithProject:selectedProject];
    
    // Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addProject:(id)sender
{
    
}

- (void)refreshList:(id)sender
{
    
}

@end
