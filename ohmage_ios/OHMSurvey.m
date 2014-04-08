//
//  OHMSurvey.m
//  ohmage_ios
//
//  Created by Charles Forkish on 3/13/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMSurvey.h"

@implementation OHMSurvey

+ (instancetype)loadFromServerWithDefinition:(NSDictionary *)surveyDefinition
{
    return [[OHMSurvey alloc] initWithId:[surveyDefinition surveyId] version:[surveyDefinition surveyVersion]];
}

- (id)initWithId:(NSString *)surveyId version:(NSInteger)surveyVersion
{
    self = [super init];
    if (self) {
        self.ohmId = surveyId;
        self.surveyVersion = surveyVersion;
        self.isLoaded = NO;
        [self updateFromServer];
    }
    return self;
}

- (NSString *)definitionRequestUrlString
{
    return [NSString stringWithFormat:@"surveys/%@/%ld", self.ohmId, (long)self.surveyVersion];
}

- (void)updateFromServer
{
    __weak OHMSurvey *weakSelf = self;
    
    [self.httpClient getRequest:[self definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error updating survey: %@", [error localizedDescription]);
        }
        else {
            NSLog(@"got survey: %@, version: %ld", [response surveyName], weakSelf.surveyVersion);
            weakSelf.surveyName = [response surveyName];
            weakSelf.surveyDescription = [response surveyDescription];
            weakSelf.isLoaded = YES;
            if (self.surveyUpdatedBlock) {
                self.surveyUpdatedBlock();
            }
        }
    }];
}

@end
