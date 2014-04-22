#import "OHMSurvey.h"

@interface OHMSurvey ()

@property (nonatomic, strong) NSMutableArray *privateItems;

@end

@implementation OHMSurvey

+ (instancetype)loadFromServerWithDefinition:(NSDictionary *)surveyDefinition
{
    return [[OHMSurvey alloc] initWithId:[surveyDefinition surveyId] version:[surveyDefinition surveyVersion]];
}

- (id)initWithId:(NSString *)surveyId version:(NSInteger)surveyVersion
{
    self = [super init];
    if (self) {
        self.privateItems = [NSMutableArray array];
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

- (NSArray *)surveyItems
{
    return self.privateItems;
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
            [weakSelf parseSurveyItems:[response surveyItems]];
            weakSelf.isLoaded = YES;
            if (self.surveyUpdatedBlock) {
                self.surveyUpdatedBlock();
            }
        }
    }];
}

- (void)parseSurveyItems:(NSArray *)itemDefinitions
{
    for (NSDictionary * definition in itemDefinitions) {
        OHMSurveyItem *item = [OHMSurveyItem itemWithDefinition:definition];
        if (item) {
            [self.privateItems addObject:item];
        }
        //        NSLog(@"Parsed item: %@", item);
    }
}

@end