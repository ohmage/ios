//
//  OHMPromptCondition.m
//  ohmage_ios
//
//  Created by Charles Forkish on 4/27/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "OHMPromptCondition.h"

typedef NS_ENUM(NSUInteger, ConjunctionFragmentGroupNumber) {
    eConjunctionGroupNegation = 1,
    eConjunctionGroupFirstFragment,
    eConjunctionGroupConjunction,
    eConjunctionGroupSecondFragment
};

typedef NS_ENUM(NSUInteger, ComparisonFragmentGroupNumber) {
    eComparisonGroupFirstTerminal = 1,
    eComparisonGroupComparator,
    eComparisonGroupSecondTerminal
};

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


static const NSRange kRangeNotFound = {NSNotFound, 0};


@interface OHMPromptCondition ()

@property (nonatomic, copy) NSString *conditionString;

@end

@implementation OHMPromptCondition

- (instancetype)initWithConditionString:(NSString *)conditionString
{
    self = [super init];
    if (self) {
        self.conditionString = conditionString;
        
    }
    return self;
}

+ (NSRegularExpression *)basicConjunctionRegex
{
    static NSRegularExpression *regex = nil;
    if (regex == nil) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"\
                                      \\A(?>\\s*)(!?)(?>\\s*) # group 1: negation \n\
                                      ([^()]+?)               # group 2: first fragment \n\
                                      (?:(?>\\s*)(AND|OR)     # group 3 (optional): conjunction \n\
                                      (?>\\s*)(.*))?\\z       # group 4 (optional): second fragment"
                                                                               options:NSRegularExpressionAllowCommentsAndWhitespace
                                                                                 error:nil];
    }
    return regex;
}

+ (NSRegularExpression *)nestedConjunctionRegex
{
    static NSRegularExpression *regex = nil;
    if (regex == nil) {
        NSError *error = nil;
//        regex = [NSRegularExpression regularExpressionWithPattern:@"\
//                 \\A(?>\\s*)(!?)(?>\\s*) # group 1: negation \n\
//                 (\\((?>[^()]|(?2))*+\\)) # group 2: first fragment \n\
//                 (?:(?>\\s*)(AND|OR)     # group 3 (optional): conjunction \n\
//                 (?>\\s*)(.*))?\\z       # group 4 (optional): second fragment"
//                                                          options:NSRegularExpressionAllowCommentsAndWhitespace
        //                                                            error:&error];
        regex = [NSRegularExpression regularExpressionWithPattern:@"\
                 \\A(?>\\s*)(!?)(?>\\s*) # group 1: negation \n\
                 (\\((?>[^()]|\\2)*+\\))              # group 2: first fragment \n\
                 (?:(?>\\s*)(AND|OR)     # group 3 (optional): conjunction \n\
                 (?>\\s*)(.*))?\\z       # group 4 (optional): second fragment"
                                                          options:NSRegularExpressionAllowCommentsAndWhitespace
                                                            error:&error];
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
        else {
            NSLog(@"REGEX: %@", regex.pattern);
        }
    }
    return regex;
}

+ (NSRegularExpression *)comparisonRegex
{
    static NSRegularExpression *regex = nil;
    if (regex == nil) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"\
                 ^\\s*+((?:[^()!=<>\\s](?!AND|OR))++)    # group 1: first terminal \n\
                 \\s*+(==|!=|>|<|>=|=>|<=|=<)\\s*+       # group 2: comparator \n\
                 ((?>[^()!=<>](?!AND|OR))+)$             # group 3: second terminal"
                                                          options:NSRegularExpressionAllowCommentsAndWhitespace
                                                            error:nil];
    }
    return regex;
}


+ (void)testString:(NSString *)test
{
    NSLog(@"STARTING TEST: %@", test);
    BOOL result = [self recursivelyEvaluateFragment:test];
    NSLog(@"TEST: %@ evaluated to: %d", test, result);
}

+ (void)test
{
    [self testString:test1];
    [self testString:test11];
    [self testString:test111];
    [self testString:test1111];
    [self testString:test2];
    [self testString:test3];
}

+ (BOOL)fragmentIsTerminal:(NSString *)fragment
{
    static NSRegularExpression *regex = nil;
    if (regex == nil) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\A\\s*+((?:[^()\\s](?!AND|OR))++)\\s*\\z"
                                                          options:0
                                                            error:nil];
    }
    return ([regex numberOfMatchesInString:fragment options:0 range:NSMakeRange(0, [fragment length])] > 0);
}

+ (BOOL)matchIsNegated:(NSTextCheckingResult *)match
{
    return ([match rangeAtIndex:eConjunctionGroupNegation].length > 0);
}

+ (NSString *)firstFragmentInMatch:(NSTextCheckingResult *)match fromString:(NSString *)string
{
    NSRange range = [match rangeAtIndex:eConjunctionGroupFirstFragment];
    if (NSEqualRanges(range, kRangeNotFound)) {
        return nil;
    }
    else {
        return [string substringWithRange:range];
    }
}

+ (NSString *)conjunctionInMatch:(NSTextCheckingResult *)match fromString:(NSString *)string
{
    NSRange range = [match rangeAtIndex:eConjunctionGroupConjunction];
    if (NSEqualRanges(range, kRangeNotFound)) {
        return nil;
    }
    else {
        return [string substringWithRange:range];
    }
}

+ (NSString *)secondFragmentInMatch:(NSTextCheckingResult *)match fromString:(NSString *)string
{
    NSRange range = [match rangeAtIndex:eConjunctionGroupSecondFragment];
    if (NSEqualRanges(range, kRangeNotFound)) {
        return nil;
    }
    else {
        return [string substringWithRange:range];
    }
}

+ (NSString *)fragmentByRemovingParenthesesFromFragment:(NSString *)fragment
{
    
    static NSRegularExpression *regex = nil;
    if (regex == nil) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\A\\s*+\\((.+?)\\)\\s*\\z"
                                                          options:0
                                                            error:nil];
    }
    NSTextCheckingResult *match = [regex firstMatchInString:fragment options:0 range:NSMakeRange(0, [fragment length])];
    if (match) {
        return [fragment substringWithRange:[match rangeAtIndex:1]];
    }
    else {
        return nil;
    }
    
}

+ (NSTextCheckingResult *)matchForComparisonFragment:(NSString *)fragment
{
    NSTextCheckingResult *match = [[self comparisonRegex] firstMatchInString:fragment options:0 range:NSMakeRange(0, [fragment length])];
    if (match) {
        NSLog(@"matched comparison fragment: %@", fragment);
        return match;
    }
    else {
        NSLog(@"failed to match comparison fragment: %@", fragment);
        return nil;
    }
}

+ (BOOL)evaluateTerminalFragment:(NSString *)fragment
{
    if ([fragment isEqualToString:kTerminalSKIPPED]) {
        return NO;
    }
    else if ([fragment isEqualToString:kTerminalNOT_DISPLAYED]) {
        return NO;
    }
    else {
        NSLog(@"returning YES for terminal fragment: %@", fragment);
        return YES;
    }
    return NO;
}

+ (BOOL)evaluateComparisonFragment:(NSString *)fragment withMatch:(NSTextCheckingResult *)match
{
    NSString *firstPart = [fragment substringWithRange:[match rangeAtIndex:eComparisonGroupFirstTerminal]];
    NSString *comparator = [fragment substringWithRange:[match rangeAtIndex:eComparisonGroupComparator]];
    NSString *secondPart = [fragment substringWithRange:[match rangeAtIndex:eComparisonGroupSecondTerminal]];
    
    NSLog(@"returning YES for comparison fragment: %@, firstPart: %@, comparator: %@, secondPart: %@", fragment, firstPart, comparator, secondPart);
    
    return YES;
}

+ (BOOL)evaluateConjunctionFragment:(NSString *)fragment withMatch:(NSTextCheckingResult *)match
{
    BOOL negated = [self matchIsNegated:match];
    NSString *firstPart = [self firstFragmentInMatch:match fromString:fragment];
    NSString *conjunction = [self conjunctionInMatch:match fromString:fragment];
    NSString *secondPart = [self secondFragmentInMatch:match fromString:fragment];
    
    NSLog(@"negated: %d, firstPart: %@, conjunction: %@, secondPart: %@", negated, firstPart, conjunction, secondPart);
    
    if (secondPart) {
        if ([conjunction isEqualToString:kConjunctionAND]) {
            if (negated) {
                return ![self recursivelyEvaluateFragment:firstPart] && [self recursivelyEvaluateFragment:secondPart];
            }
            else {
                return [self recursivelyEvaluateFragment:firstPart] && [self recursivelyEvaluateFragment:secondPart];
            }
        }
        else  if ([conjunction isEqualToString:kConjunctionOR]) {
            if (negated) {
                return ![self recursivelyEvaluateFragment:firstPart] || [self recursivelyEvaluateFragment:secondPart];
            }
            else {
                return [self recursivelyEvaluateFragment:firstPart] || [self recursivelyEvaluateFragment:secondPart];
            }
        }
    }
    else {
        if (negated) {
            return ![self recursivelyEvaluateFragment:firstPart];
        }
        else {
            return [self recursivelyEvaluateFragment:firstPart];
        }
    }
    
    return NO;
}

+ (BOOL)recursivelyEvaluateFragment:(NSString *)fragment
{
    if ([self fragmentIsTerminal:fragment]) {
        return [self evaluateTerminalFragment:fragment];
    }
    
    NSTextCheckingResult *match = [self matchForComparisonFragment:fragment];
    if (match) {
        return [self evaluateComparisonFragment:fragment withMatch:match];
    }
    
    match = [[self basicConjunctionRegex] firstMatchInString:fragment options:0 range:NSMakeRange(0, [fragment length])];
    if (!match) {
        match = [[self nestedConjunctionRegex] firstMatchInString:fragment options:0 range:NSMakeRange(0, [fragment length])];
        if (!match) {
            NSLog(@"failed to match fragment: %@", fragment);
            return NO;
        }
    }
    
    return [self evaluateConjunctionFragment:fragment withMatch:match];
}

- (BOOL)parseConditionString:(NSString *)conditionString
{
    
    
    return NO;
}

@end
