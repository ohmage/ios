// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <TDTemplateEngine/TDTemplateContext.h>
#import <TDTemplateEngine/TDWriter.h>

@interface TDTemplateContext ()
@property (nonatomic, retain) NSMutableDictionary *vars;
@property (nonatomic, retain, readwrite) TDWriter *writer;
@end

@implementation TDTemplateContext

- (instancetype)init {
    self = [self initWithVariables:nil output:nil];
    return self;
}


- (instancetype)initWithVariables:(NSDictionary *)vars output:(NSOutputStream *)output {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
        [_vars addEntriesFromDictionary:vars];

        self.writer = [TDWriter writerWithOutputStream:output];
    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    self.writer = nil;
    self.enclosingScope = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p global: %d, %@>", [self class], self, nil == self.enclosingScope, self.vars];
}


#pragma mark -
#pragma mark TDScope

- (id)resolveVariable:(NSString *)name {
    NSParameterAssert([name length]);
    TDAssert(_vars);
    id result = _vars[name];
    
    if (!result && self.enclosingScope) {
        result = [self.enclosingScope resolveVariable:name];
    }
    
    return result;
}


- (void)defineVariable:(NSString *)name value:(id)value {
    //NSLog(@"%s %@=%@", __PRETTY_FUNCTION__, name, value);

    NSParameterAssert([name length]);
    TDAssert(_vars);
    if (value) {
        _vars[name] = value;
    } else {
        //TDAssert(_vars[name]);
        [_vars removeObjectForKey:name];
    }
}

@end
