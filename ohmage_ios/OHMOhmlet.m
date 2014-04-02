//
//  OHMOhmlet.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/1/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMOhmlet.h"
#import "OHMSurvey.h"

@interface OHMOhmlet ()

@property (nonatomic, strong) NSMutableArray *surveys;

@end

@implementation OHMOhmlet

+ (instancetype)loadFromServerWithId:(NSString *)ohmletId
{
    return [[OHMOhmlet alloc] initWithId:ohmletId];
}

- (id)initWithId:(NSString *)ohmletId
{
    self = [super init];
    if (self) {
        self.ohmId = ohmletId;
        [self updateFromServer];
    }
    return self;
}

- (NSString *)definitionRequestUrlString
{
    return [@"ohmlets/" stringByAppendingString:self.ohmId];
}

- (void)updateFromServer
{
    __weak OHMOhmlet *weakSelf = self;
    
    [self.httpClient getRequest:[self definitionRequestUrlString] withParameters:nil completionBlock:^(NSDictionary *response, NSError *error) {
        if (error) {
            NSLog(@"Error updating Ohmlet: %@", [error localizedDescription]);
        }
        else {
            weakSelf.ohmletName = [response ohmletName];
            weakSelf.ohmletDescription = [response ohmletDescription];
            [weakSelf refreshSurveys:[response surveyDefinitions]];
        }
    }];
}

- (void)refreshSurveys:(NSArray *)surveyDefinitions
{
    NSMutableArray *toCreate = [surveyDefinitions mutableCopy];
    NSMutableArray *toUpdate = [NSMutableArray array];
    NSMutableArray *toRemove = [NSMutableArray array];
    
    for (OHMSurvey *survey in self.surveys) {
        
        NSUInteger existingIndex = [surveyDefinitions indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [survey.ohmId isEqualToString:[(NSDictionary *)obj surveyId]];
        }];
        
        if (existingIndex != NSNotFound) {
            NSDictionary *existingDescription = [surveyDefinitions objectAtIndex:existingIndex];
            if (survey.surveyVersion < [existingDescription surveyVersion]) {
                [toUpdate addObject:survey];
            }
            else {
                [toCreate removeObject:existingDescription];
            }
        }
        else {
            [toRemove addObject:survey];
        }
    }
    
    [self.surveys removeObjectsInArray:toRemove];
    [self createSurveys:toCreate];
    [self updateSurveys:toUpdate];
}

- (void)createSurveys:(NSArray *)surveyDefinitions
{
    for (NSDictionary *surveyDefinition in surveyDefinitions) {
        [OHMSurvey loadFromServerWithDefinition:surveyDefinition];
    }
}

- (void)updateSurveys:(NSArray *)staleSurveys
{
    for (OHMSurvey *survey in staleSurveys) {
        [survey updateFromServer];
    }
}

@end
