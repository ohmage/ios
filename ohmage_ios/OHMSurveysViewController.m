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

@interface OHMSurveysViewController () <OHMClientDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) OHMClient *client;
@property (nonatomic, strong) OHMOhmlet *ohmlet;
@property (nonatomic) NSInteger ohmletIndex;

@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) UILabel *ohmletNameLabel;
@property (nonatomic, weak) UILabel *ohmletDescriptionLabel;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

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
    self.tableView.separatorColor = [UIColor clearColor];
//    self.tableView.separatorColor = [OHMAppConstants lightOhmageColor];
//    self.tableView.backgroundColor = [OHMAppConstants lightOhmageColor];
    
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
    
    
    self.client = [OHMClient sharedClient];
    self.client.delegate = self;
    
    [self.tableView registerClass:[OHMSurveyTableViewCell class]
           forCellReuseIdentifier:@"OHMSurveyTableViewCell"];
    
    if ([[self.client ohmlets] count] > self.ohmletIndex) {
        self.ohmlet = [self.client ohmlets][self.ohmletIndex];
    }
    
    [self setupHeader];
    
    self.fetchedResultsController = [[OHMClient sharedClient] fetchedResultsControllerWithEntityName:[OHMSurvey entityName] sortKey:@"surveyName" predicate:nil sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
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
    [self updateFetchedResultsController];
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
    NSString *nameText = nil;
    if (self.ohmlet) {
        nameText = self.ohmlet.ohmletName ? self.ohmlet.ohmletName : self.ohmlet.ohmID;
    }
    else {
        nameText = @"Loading Data";
    }
    
    CGFloat contentWidth = self.tableView.bounds.size.width - 2 * kUIViewHorizontalMargin;
    CGFloat contentHeight = kUIViewVerticalMargin;
    
    UILabel *nameLabel = [OHMUserInterface headerTitleLabelWithText:nameText width:contentWidth];
    contentHeight += nameLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UILabel *descriptionLabel = [OHMUserInterface headerDescriptionLabelWithText:self.ohmlet.ohmletDescription width:contentWidth];
    contentHeight += descriptionLabel.frame.size.height + kUIViewSmallTextMargin;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = MAX([self.client.ohmlets count], 1);
    pageControl.currentPage = self.ohmletIndex;
    [pageControl addTarget:self action:@selector(pageControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [pageControl constrainSize:CGSizeMake(contentWidth, 20)];
    contentHeight += pageControl.frame.size.height + kUIViewSmallTextMargin;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, contentHeight)];
    headerView.backgroundColor = [OHMAppConstants lightOhmageColor];
//    [OHMUserInterface applyRoundedBorderToView:headerView];
    
    [headerView addSubview:nameLabel];
    [headerView addSubview:descriptionLabel];
    [headerView addSubview:pageControl];
    
    [nameLabel centerHorizontallyInView:headerView];
    [descriptionLabel centerHorizontallyInView:headerView];
    [pageControl centerHorizontallyInView:headerView];
    
    [pageControl constrainToTopInParentWithMargin:kUIViewSmallTextMargin];
    [nameLabel positionBelowElement:pageControl margin:kUIViewSmallTextMargin];
    [descriptionLabel positionBelowElement:nameLabel margin:kUIViewSmallTextMargin];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerDidSwipeRight:)];
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerDidSwipeLeft:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [headerView addGestureRecognizer:rightSwipe];
    [headerView addGestureRecognizer:leftSwipe];
    
    self.tableView.tableHeaderView = headerView;
    self.pageControl = pageControl;
    self.ohmletNameLabel = nameLabel;
    self.ohmletDescriptionLabel = descriptionLabel;
    
}

- (void)pageControlValueChanged:(id)sender
{
    NSInteger oldIndex = self.ohmletIndex;
    self.ohmletIndex = self.pageControl.currentPage;
    [self OHMClientDidUpdate:[OHMClient sharedClient]];
    UITableViewRowAnimation animation = (oldIndex < self.ohmletIndex ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight);
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:animation];
}

- (void)headerDidSwipeRight:(id)sender
{
    if (self.pageControl.currentPage > 0) {
        self.pageControl.currentPage -= 1;
        [self pageControlValueChanged:self.pageControl];
    }
}

- (void)headerDidSwipeLeft:(id)sender
{
    if (self.pageControl.currentPage < self.pageControl.numberOfPages) {
        self.pageControl.currentPage += 1;
        [self pageControlValueChanged:self.pageControl];
    }
}

- (void)updateFetchedResultsController
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ohmlet == %@", self.ohmlet];
    self.fetchedResultsController.fetchRequest.predicate = predicate;
    
    NSError *error;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    if (!success) {
        NSLog(@"Error fetching surveys for ohmlet. Error: %@, Ohmlet: %@", [error localizedDescription], self.ohmlet);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return MAX([[self.fetchedResultsController sections] count], 1);
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OHMSurveyTableViewCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row >= [[self.fetchedResultsController fetchedObjects] count]) {
        NSLog(@"no survey for row: %d", indexPath.row);
        return;
    }
    
    OHMSurvey *survey = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (survey.isLoaded) {
        cell.textLabel.text = survey.surveyName;
        //        cell.detailTextLabel.text = survey.surveyDescription;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.backgroundColor = [OHMAppConstants lightColorForRowIndex:indexPath.row];
        
        //        [OHMUserInterface applyRoundedBorderToView:cell];
        cell.tintColor = [UIColor darkTextColor];
        survey.colorIndex = indexPath.row;
        //        CGFloat height = [OHMUserInterface heightForSubtitleCellWithTitle:cell.textLabel.text subtitle:cell.detailTextLabel.text accessoryType:cell.accessoryType];
        //        NSLog(@"height for cell %ld: %f", indexPath.row, height);
    }
    
    //    survey.surveyUpdatedBlock = ^{
    //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = [self.fetchedResultsController objectAtIndexPath:indexPath];
    OHMSurveyResponse *newResponse = [[OHMClient sharedClient] buildResponseForSurvey:survey];
    OHMSurveyItemViewController *vc = [OHMSurveyItemViewController viewControllerForSurveyResponse:newResponse atQuestionIndex:0];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = [self.fetchedResultsController objectAtIndexPath:indexPath];
    OHMSurveyDetailViewController *vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:survey];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurvey *survey = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return [OHMUserInterface heightForSubtitleCellWithTitle:survey.surveyName
                                                   subtitle:nil//survey.surveyDescription
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
        
        [self updateFetchedResultsController];
        [self setupHeader];
//        [self.tableView reloadData];
    }
}


#pragma mark - NSFetchedResultsController Delegate

- (void)controllerWillChangeContent:
(NSFetchedResultsController *)controller
{
    NSLog(@"controller will change content");
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:
(NSFetchedResultsController *)controller
{
    NSLog(@"controller did change content");
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    NSLog(@"controller did change section info type: %d", type);
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    NSLog(@"controller did change oject, type: %d", type);
    UITableView *tableView = self.tableView;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView
             deleteRowsAtIndexPaths:@[indexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView
             insertRowsAtIndexPaths:@[newIndexPath]
             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

@end
