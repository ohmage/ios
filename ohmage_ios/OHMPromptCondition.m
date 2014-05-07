//
//  OHMPromptCondition.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMPromptCondition.h"
#import "OHMConditionParser.h"
#import <PEGKit/PEGKit.h>

NSString *const kConjunctionAND = @"AND";
NSString *const kConjunctionOR = @"OR";

NSString *const kTerminalSKIPPED = @"SKIPPED";
NSString *const kTerminalNOT_DISPLAYED = @"NOT_DISPLAYED";



NSString *const test1 = @"! somePreviousPromptId == 3 AND anotherPreviousPromptId == \"Hello, world.\"";
NSString *const test11 = @"somePreviousPromptId == 3";
NSString *const test111 = @"somePreviousPromptId == 3 AND anotherPreviousPromptId == \"Hello, world.\"";
NSString *const test1111 = @"anotherPreviousPromptId == \"Hello, world.\"";

NSString *const test2 = @"(somePreviousPromptId == 3) AND anotherPreviousPromptId == \"Hello, world.\"";

NSString *const test3 = @"(somePreviousPromptId == 3 AND somePreviousPromptId == \"Hello, world.\")";


@interface OHMPromptCondition ()

@property (nonatomic, copy) NSString *conditionString;

@end

@implementation OHMPromptCondition

- (instancetype)initWithConditionString:(NSString *)conditionString
{
    self = [super init];
    if (self) {
        self.conditionString = conditionString;
        [self test];
        
    }
    return self;
}

- (void)parser:(OHMConditionParser *)parser didMatchAtom:(PKAssembly *)result
{
    NSLog(@"did match atom: %@", result);
}

- (void)parser:(OHMConditionParser *)parser didMatchOhmID:(PKAssembly *)result
{
    NSLog(@"did match ID: %@", result);
    NSString *promptID = [result pop];
    NSLog(@"promptID: %@", promptID);
    [result push:@"Hello, world."];
    
}

- (BOOL)evaluateString:(NSString *)string
{
    OHMConditionParser *parser = [[OHMConditionParser alloc] initWithDelegate:self];
    
    NSError *err = nil;
    PKAssembly *result = [parser parseString:string error:&err];
    
    if (!result) {
        if (err) NSLog(@"Parse error: %@", err);
        return NO;
    }
    else {
        NSLog(@"result: %@", result);
        
        NSNumber *n = [result pop];
        return [n boolValue];
    }

    return YES;
}


- (void)testString:(NSString *)test
{
    NSLog(@"STARTING TEST: %@", test);
    BOOL result = [self evaluateString:test];
    NSLog(@"TEST: %@ evaluated to: %d", test, result);
}

- (void)test
{
    [self testString:test1];
    [self testString:test11];
    [self testString:test111];
    [self testString:test1111];
    [self testString:test2];
    [self testString:test3];
}



- (BOOL)parseConditionString:(NSString *)conditionString
{
    
    
    return NO;
}

@end
