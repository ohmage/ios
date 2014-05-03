//
//  OHMSurveyResponseViewController.m
//  ohmage_ios
//
//  Created by Charles Forkish on 5/2/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurveyResponseViewController.h"
#import "OHMSurveyItemViewController.h"
#import "OHMSurveyDetailViewController.h"
#import "OHMSurveyResponse.h"
#import "OHMSurvey.h"
#import "OHMSurveyPromptResponse.h"
#import "OHMSurveyItem.h"
#import "OHMSurveyPromptChoice.h"


@interface OHMSurveyResponseViewController ()

@property (nonatomic, strong) OHMSurveyResponse *response;

@end

@implementation OHMSurveyResponseViewController


- (instancetype)initWithSurveyResponse:(OHMSurveyResponse *)response
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.response = response;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Survey Response";

}

- (void)setupSubmitHeader
{
    UIView *headerView = [OHMUserInterface tableFooterViewWithButton:@"Submit" fromTableView:self.tableView setupBlock:^(UIButton *button) {
        [button addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [OHMAppConstants colorForRowIndex:self.response.survey.colorIndex];
    }];
    self.tableView.tableHeaderView = headerView;
}



- (void)submitButtonPressed:(id)sender
{
    self.response.timestamp = [NSDate date];
    [[OHMClient sharedClient] saveClientState];
    
    UIViewController *vc = self.navigationController.viewControllers[1];
    if (![vc isKindOfClass:[OHMSurveyDetailViewController class]]) {
        vc = [[OHMSurveyDetailViewController alloc] initWithSurvey:self.response.survey];
        NSMutableArray *vcStack = [self.navigationController.viewControllers mutableCopy];
        [vcStack insertObject:vc atIndex:1];
        self.navigationController.viewControllers = vcStack;
    }
    
    [self.navigationController popToViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.response.promptResponses.count;
}

- (NSString *)detailTextForMultiChoiceResponse:(OHMSurveyPromptResponse *)promptResponse
{
    NSMutableString *text = [NSMutableString string];
    
    for (OHMSurveyPromptChoice *choice in promptResponse.selectedChoices) {
        [text appendFormat:@"%@: ", choice.text];
        if (promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeNumberMultiChoicePrompt) {
            [text appendFormat:@"%g\n", choice.numberValueValue];
        }
        else {
            [text appendFormat:@"%@\n", choice.stringValue];
        }
    }
    
    return text;
}

- (NSString *)detailTextForPromptResponse:(OHMSurveyPromptResponse *)promptResponse
{
    if (promptResponse.skippedValue) {
        return @"<Skipped>";
    }
    
    switch (promptResponse.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeMessage:
            return nil;
        case OHMSurveyItemTypeImagePrompt:
            return nil;
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            return [self detailTextForMultiChoiceResponse:promptResponse];
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeTextPrompt:
            return promptResponse.stringValue;
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberPrompt:
            return [NSString stringWithFormat:@"%g", promptResponse.numberValueValue];
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    OHMSurveyPromptResponse *promptResponse = self.response.promptResponses[indexPath.row];
    
    if (promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt) {
        cell = [OHMUserInterface cellWithImage:promptResponse.imageValue fromTableView:tableView];
    }
    else {
        cell = [OHMUserInterface cellWithSubtitleStyleFromTableView:tableView];
    }
    
    cell.textLabel.text = promptResponse.surveyItem.text;
    cell.detailTextLabel.text = [self detailTextForPromptResponse:promptResponse];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyPromptResponse *promptResponse = self.response.promptResponses[indexPath.row];
    
    CGFloat height = [OHMUserInterface heightForSubtitleCellWithTitle:promptResponse.surveyItem.text
                                                   subtitle:[self detailTextForPromptResponse:promptResponse]
                                              accessoryType:UITableViewCellAccessoryNone
                                              fromTableView:tableView];
    
    if (promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt) {
        height += kUICellImageHeight;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    OHMSurveyPromptResponse *promptResponse = self.response.promptResponses[indexPath.row];
    OHMSurveyItemViewController *vc = [[OHMSurveyItemViewController alloc] initWithSurveyResponse:self.response atQuestionIndex:indexPath.row];
//    [vc prepareForModalPresentation];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navCon animated:YES completion:nil];
    
}

@end
