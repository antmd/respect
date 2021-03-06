// Copyright (c) 2013 <mattias.wadman@gmail.com>
//
// MIT License:
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

#import "PBXUnarchiver.h"
#import <objc/runtime.h>

@interface PBXUnarchiver ()
@property(nonatomic, retain, readwrite) NSDictionary *objects;
@property(nonatomic, retain, readwrite) NSString *rootObjectId;
@property(nonatomic, retain, readwrite) NSMutableDictionary *objectIdMap;
@end

@implementation PBXUnarchiver
@synthesize allowedClasses = _allowedClasses;
@synthesize objects = _objects;
@synthesize rootObjectId = _rootObjectId;
@synthesize objectIdMap = _objectIdMap;

- (id)initWithFile:(NSString *)path {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    NSDictionary *pbxDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (pbxDict == nil) {
        return nil;
    }
    
    self.rootObjectId = [pbxDict objectForKey:@"rootObject"];
    self.objects = [pbxDict objectForKey:@"objects"];
    self.objectIdMap = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)dealloc {
    self.allowedClasses = nil;
    self.objects = nil;
    self.rootObjectId = nil;
    self.objectIdMap = nil;
    
    [super dealloc];
}

- (id)decodeValue:(id)value {
    if ([value isKindOfClass:[NSString class]]) {
        id object = [self.objectIdMap objectForKey:value];
        if (object != nil) {
            return object;
        } else if ([self.objects objectForKey:value]) {
            object = [self decodeObject:[self.objects objectForKey:value]];
            if (object == nil) {
                return nil;
            }
            [self.objectIdMap setObject:object forKey:value];
            
            return object;
        } else {
            return value;
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSMutableArray *decodedArray = [NSMutableArray array];
        for (id object in value) {
            id decodedObject = [self decodeValue:object];
            if (decodedObject == nil) {
                continue;
            }
            
            [decodedArray addObject:decodedObject];
        }
        
        return decodedArray;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *decodedDict = [NSMutableDictionary dictionary];
        for (id key in value) {
            id decodedObject = [self decodeValue:[value objectForKey:key]];
            if (decodedObject == nil) {
                continue;
            }
            
            [decodedDict setObject:decodedObject forKey:key];
        }
        
        return decodedDict;
    }
    
    return nil;
}

- (id)decodeObject:(id)objectDict {
    if (objectDict == nil || ![objectDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *objectIsa = [objectDict objectForKey:@"isa"];
    if (objectIsa == nil || ![objectIsa isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    Class objectClass = NSClassFromString(objectIsa);
    if (objectClass == nil) {
        return nil;
    }
    
    if (self.allowedClasses != nil &&
        ![self.allowedClasses containsObject:objectClass]) {
        return nil;
    }
    
    id objectInstance = [[[objectClass alloc] init] autorelease];
    
    for (NSString *key in objectDict) {
        if (class_getProperty(objectClass, [key UTF8String]) == NULL) {
            continue;
        }
        
        [objectInstance setValue:[self decodeValue:[objectDict objectForKey:key]]
                          forKey:key];
    }
    
    return objectInstance;
}

- (id)decodeObject {
    if (self.rootObjectId == nil ||
        ![self.rootObjectId isKindOfClass:[NSString class]] ||
        self.objects == nil ||
        ![self.objects isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [self decodeValue:self.rootObjectId];
}

@end
