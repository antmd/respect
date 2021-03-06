// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#import "ResourceLinterAbstractReport.h"

@interface ResourceLinterAbstractReport ()
@property(nonatomic, retain, readwrite) ResourceLinter *linter;
@property(nonatomic, retain, readwrite) NSMutableString *outputBuffer;
@end

@implementation ResourceLinterAbstractReport
@synthesize linter = _linter;
@synthesize outputBuffer = _outputBuffer;

- (id)initWithLinter:(ResourceLinter *)linter {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.linter = linter;
    self.outputBuffer = [NSMutableString string];
    
    return self;
}

- (void)dealloc {
    self.linter = nil;
    self.outputBuffer = nil;
    
    [super dealloc];
}

- (void)addLine:(NSString *)format arguments:(va_list)va {
    [self.outputBuffer appendString:[[[NSString alloc] initWithFormat:format
                                                            arguments:va]
                                     autorelease]];
    [self.outputBuffer appendString:@"\n"];
}

- (void)addLine:(NSString *)format, ... {
    va_list va;
    va_start(va, format);
    [self addLine:format arguments:va];
    va_end(va);
}

- (void)addLines:(NSArray *)lines {
    for (NSString *line in lines) {
        [self addLine:@"%@", line];
    }
}

@end
