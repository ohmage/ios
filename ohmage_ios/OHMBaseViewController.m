//
//  OHMBaseViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMBaseViewController.h"

@interface OHMBaseViewController ()

@end

@implementation OHMBaseViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.viewControllerComposite = [[OHMViewControllerComposite alloc] initWithViewController:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonSetup];
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

@end
