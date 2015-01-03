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
@property (nonatomic) BOOL canEditResponse;

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
    
    self.canEditResponse = YES;

    if (self.response.userSubmittedValue) {
        self.canEditResponse = NO;
    }
    else {
        [self setupSubmitHeader];
        
        // don't allow editing of surveys with conditions
        for (OHMSurveyPromptResponse * promptResponse in self.response.promptResponses) {
            if (promptResponse.surveyItem.condition != nil) {
                self.canEditResponse = NO;
                break;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setupSubmitHeader
{
    UIView *headerView = [OHMUserInterface tableFooterViewWithButton:@"Submit" fromTableView:self.tableView setupBlock:^(UIButton *button) {
        [button addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [OHMAppConstants colorForSurveyIndex:self.response.survey.indexValue];
    }];
    self.tableView.tableHeaderView = headerView;
}

- (void)submitButtonPressed:(id)sender
{
    [[OHMModel sharedModel] submitSurveyResponse:self.response];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.response.displayedPromptResponses.count;
}

- (NSString *)detailTextForMultiChoiceResponse:(OHMSurveyPromptResponse *)promptResponse
{
    NSMutableString *text = [NSMutableString string];
    
    for (OHMSurveyPromptChoice *choice in promptResponse.selectedChoices) {
        [text appendFormat:@"%@\n", choice.text];
    }
    
    return text;
}

- (NSString *)detailTextForPromptResponse:(OHMSurveyPromptResponse *)promptResponse
{
    if (promptResponse.skippedValue) {
        return @"<Skipped>";
    }
    else if (promptResponse.notDisplayedValue) {
        return @"<Not displayed>";
    }
    
    switch (promptResponse.surveyItem.itemTypeValue) {
        case OHMSurveyItemTypeMessage:
            return nil;
        case OHMSurveyItemTypeImagePrompt:
            return nil;
        case OHMSurveyItemTypeNumberSingleChoicePrompt:
        case OHMSurveyItemTypeNumberMultiChoicePrompt:
        case OHMSurveyItemTypeStringSingleChoicePrompt:
        case OHMSurveyItemTypeStringMultiChoicePrompt:
            return [self detailTextForMultiChoiceResponse:promptResponse];
        case OHMSurveyItemTypeTextPrompt:
            return promptResponse.stringValue;
        case OHMSurveyItemTypeNumberPrompt:
            return [NSString stringWithFormat:@"%g", promptResponse.numberValueValue];
        case OHMSurveyItemTypeTimestampPrompt:
            return [OHMUserInterface formattedDate:promptResponse.timestampValue];
        default:
            return nil;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    OHMSurveyPromptResponse *promptResponse = self.response.displayedPromptResponses[indexPath.row];
    NSString *promptText = promptResponse.surveyItem.text;
    
    if (!promptResponse.skippedValue &&
        (promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt ||
         promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) ) {
        cell = [OHMUserInterface cellWithImage:promptResponse.imageValue text:promptText fromTableView:tableView];
    }
    else {
        cell = [OHMUserInterface cellWithSubtitleStyleFromTableView:tableView];
        cell.textLabel.text = promptText;
    }
    
    cell.detailTextLabel.text = [self detailTextForPromptResponse:promptResponse];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OHMSurveyPromptResponse *promptResponse = self.response.displayedPromptResponses[indexPath.row];
    NSString *promptText = promptResponse.surveyItem.text;
    
    if (!promptResponse.skippedValue &&
        (promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeImagePrompt ||
         promptResponse.surveyItem.itemTypeValue == OHMSurveyItemTypeVideoPrompt) ) {
        return [OHMUserInterface heightForImageCellWithText:promptText fromTableView:tableView];
    }
    else {
        return [OHMUserInterface heightForSubtitleCellWithTitle:promptText
                                                   subtitle:[self detailTextForPromptResponse:promptResponse]
                                              accessoryType:UITableViewCellAccessoryNone
                                              fromTableView:tableView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.canEditResponse) return;
    
    OHMSurveyItemViewController *vc = [[OHMSurveyItemViewController alloc] initWithSurveyResponse:self.response atQuestionIndex:indexPath.row];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navCon animated:YES completion:nil];
    
}

@end
