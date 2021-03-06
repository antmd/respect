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

#import "TextFileError.h"

@interface TextFileError ()
@property(nonatomic, copy, readwrite) NSString *file;
@property(nonatomic, assign, readwrite) TextLocation textLocation;
@property(nonatomic, copy, readwrite) NSString *message;
@end

@implementation TextFileError
@synthesize file = _file;
@synthesize textLocation = _textLocation;
@synthesize message = _message;

- (id)initWithFile:(NSString *)file
      textLocation:(TextLocation)textLocation
           message:(NSString *)message {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.file = file;
    self.textLocation = textLocation;
    self.message = message;
    
    return self;
}

- (void)dealloc {
    self.file = nil;
    self.message = nil;
    
    [super dealloc];
}
@end
