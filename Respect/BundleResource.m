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

#import "BundleResource.h"

@interface BundleResource ()
@property(nonatomic, copy, readwrite) NSString *buildSourcePath;
@property(nonatomic, copy, readwrite) NSString *path;
@property(nonatomic, retain, readwrite) NSMutableArray *resourceReferences;
@end

@implementation BundleResource
@synthesize buildSourcePath = _buildSourcePath;
@synthesize path = _path;
@synthesize resourceReferences = _resourceReferences;

- (id)initWithBuildSourcePath:(NSString *)buildSourcePath
                         path:(NSString *)path {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    self.buildSourcePath = buildSourcePath;
    self.path = path;
    self.resourceReferences = [NSMutableArray array];
    
    return self;
}

- (void)dealloc {
    self.buildSourcePath = nil;
    self.path = nil;
    self.resourceReferences = nil;
    
    [super dealloc];
}
@end
