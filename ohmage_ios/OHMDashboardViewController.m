//
//  OHMDashboardViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/7/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMDashboardViewController.h"
#import "OHMDashboardItem.h"
#import "OHMDashboardCell.h"
#import "OHMDashboardItemTitleView.h"

#define kHeaderHeight 70.0 // 50 for logo, 20 for info bar
#define kMinimumSpacing 20.0

static NSString * const kDashboardCellIdentifier = @"DashboardCell";
static NSString * const kDashboardItemTitleIdentifier = @"DashboardItemTitle";

@interface OHMDashboardViewController ()

@property(nonatomic, copy) NSArray *dashboardObjects;

@end

@implementation OHMDashboardViewController


- (instancetype)init
{
    UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];\
    
    self = [super initWithCollectionViewLayout:flow];
    if (self) {
        
        self.navigationItem.title = @"Home";
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_logo_default"]];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[OHMDashboardCell class] forCellWithReuseIdentifier:kDashboardCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * flow = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    
    float side = fminf(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height) / 3.0;
    
    flow.itemSize = CGSizeMake(side, side);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.collectionView.bounds.size.width/3.0, self.collectionView.bounds.size.height/3.0);
//}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return eDOCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    OHMDashboardCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kDashboardCellIdentifier forIndexPath:indexPath];
    
    OHMDashboardItem * dObject = [OHMDashboardItem DashboardObjectForID:(DOID)indexPath.row];
    
    // make the cell's title the actual NSIndexPath value
    cell.label.text = dObject.name;
    cell.backgroundView = [[UIImageView alloc] initWithImage:dObject.image];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:dObject.pressedImage];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    OHMDashboardItemTitleView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:kDashboardItemTitleIdentifier
                                              forIndexPath:indexPath];
    
    OHMDashboardItem * dObject = [OHMDashboardItem DashboardObjectForID:(DOID)indexPath.row];
    
    titleView.titleLabel.text = dObject.name;
    
    return titleView;
}

@end
