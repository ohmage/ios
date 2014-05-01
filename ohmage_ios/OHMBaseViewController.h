//
//  OHMBaseViewController.h
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMViewControllerCompositeProtocol.h"
#import "OHMViewControllerComposite.h"

@interface OHMBaseViewController : UIViewController  <OHMViewControllerCompositeProtocol>

@property(nonatomic, strong) OHMViewControllerComposite *viewControllerComposite;


@end
