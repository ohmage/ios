//
//  OHMBaseTableViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseTableViewController.h"

@interface OHMBaseTableViewController ()

@end

@implementation OHMBaseTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.viewControllerComposite = [[OHMViewControllerComposite alloc] initWithViewController:self];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonSetup];
    
    self.tableView.backgroundView = self.backgroundView;
}


#pragma mark - Instance Methods

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self.viewControllerComposite respondsToSelector:aSelector]) {
        return YES;
    }
    
    return [super respondsToSelector:aSelector];
}


/**
 *  forwardingTargetForSelector
 */
- (id)forwardingTargetForSelector:(SEL)selector {
    if ([self.viewControllerComposite respondsToSelector:selector] == YES) {
        return self.viewControllerComposite;
    }
    
    return [super forwardingTargetForSelector:selector];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
