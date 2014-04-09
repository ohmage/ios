//
//  OHMSurveyItemViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/9/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyItemViewController.h"

@interface OHMSurveyItemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@end

@implementation OHMSurveyItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)skipButtonPressed:(id)sender {
}
- (IBAction)nextButtonPressed:(id)sender {
}

@end
