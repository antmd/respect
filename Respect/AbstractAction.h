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

// Common code for all actions

#import "ResourceLinter.h"
#import "TextLocation.h"
#import "ConfigError.h"
#import "DefaultConfig.h"
#import "PerformParameters.h"

@interface AbstractAction : NSObject
@property(nonatomic, assign, readonly) ResourceLinter *linter;
@property(nonatomic, copy, readonly) NSString *file;
@property(nonatomic, assign, readonly) TextLocation textLocation;
@property(nonatomic, copy, readonly) NSString *argumentString;
@property(nonatomic, assign, readonly) BOOL isDefaultConfig;

+ (NSString *)name;
+ (id)defaultConfigValueFromArgument:(NSString *)argument
                        errorMessage:(NSString **)errorMessage;

- (id)initWithLinter:(ResourceLinter *)linter
                file:(NSString *)file
        textLocation:(TextLocation)textLocation
      argumentString:(NSString *)argumentString
     isDefaultConfig:(BOOL)isDefaultConfig;
- (void)performWithParameters:(PerformParameters *)parameters;
- (NSArray *)configLines;
@end
