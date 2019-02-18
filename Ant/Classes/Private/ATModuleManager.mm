//
//  ATModuleManager.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ATModuleManager.h"
#import "ATModuleProtocol.h"
#import <objc/message.h>
#import "cache.h"

static NSMutableSet<id <ATModuleProtocol>> *modules;
static NSMutableSet<NSString *> *moduleNames;

static NSString * const kAntModuleKey = @"Modules";

NS_INLINE void setupModulesIfNeeded()
{
    if (!modules) modules = [NSMutableSet set];
    if (!moduleNames) moduleNames = [NSMutableSet set];
}

NS_INLINE id <ATModuleProtocol>moduleInstanceWithModule(Class moduleClass) {
    if (![[moduleClass class] respondsToSelector:@selector(singleton)]) {
        return [[[moduleClass class] alloc] init];
    }
    if (![[moduleClass class] respondsToSelector:@selector(shareInstance)]) {
        return [[[moduleClass class] alloc] init];
    }
    return [[moduleClass class] shareInstance];
}

static void cacheModulesIfNeeded(void);

@interface ATModuleManager() <UIApplicationDelegate>

@end

@implementation ATModuleManager

#pragma mark - internal

+ (instancetype)shareInstance {
    static ATModuleManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ATModuleManager alloc] init];
    });
    return instance;
}

+ (void)registerModule:(Class)moduleClass {
    [self addNewModule:moduleClass];
}

+ (void)registerModuleWithName:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    Class cls = NSClassFromString(moduleName);
    [self registerModule:cls];
}

+ (void)registerModuleWithNameLazily:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    Class cls = NSClassFromString(moduleName);
    [self addNewModuleLazily:cls];
}

+ (void)registerModulesFromPlistFile:(NSString *)plist {
    
    if (!plist) {
        plist = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:plist]) {
        return;
    }
    
    NSDictionary *moduleDict = [NSDictionary dictionaryWithContentsOfFile:plist];
    
    NSArray<NSString *> *modules = [moduleDict objectForKey:kAntModuleKey];
    NSAssert(modules, @"The module should contain 'Modules' key.");
    
    for (NSString *m in modules) {
        [self registerModuleWithName:m];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"application"].location != NSNotFound) {
        return [ATModuleManager instanceMethodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSString *sel = NSStringFromSelector(anInvocation.selector);
    if ([sel rangeOfString:@"application"].location == NSNotFound) return;
    cacheModulesIfNeeded();
    
    [modules enumerateObjectsUsingBlock:^(id<ATModuleProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:obj];
        }
    }];
}

#pragma mark - Private

static void cacheModulesIfNeeded() {
    if ([moduleNames count] == 0) {
        return;
    }
    if (modules.count == moduleNames.count) {
        return;
    }
   // Need to cache
    for (NSString *mName in moduleNames) {
        Class cls = NSClassFromString(mName);
        if (!cls) continue;
        id <ATModuleProtocol> obj = moduleInstanceWithModule(cls);
        if ([modules containsObject:obj]) {
            continue;
        }
        [modules addObject:obj];
    }
}

+ (BOOL)addNewModuleLazily:(Class)moduleClass {
    if (!moduleClass) {
        return NO;
    }
    if (![moduleClass conformsToProtocol: @protocol(ATModuleProtocol)]) {
        return NO;
    }
    setupModulesIfNeeded();
    
    NSString *mn = NSStringFromClass(moduleClass);
    if ([moduleNames containsObject:mn]) { // 防止重复注册
        return NO;
    }
    [moduleNames addObject:mn];
    return YES;
}

+ (void)addNewModule:(Class)moduleClass {
    if (![self addNewModuleLazily:moduleClass]) { return; }
    id <ATModuleProtocol> obj = moduleInstanceWithModule(moduleClass);
    [modules addObject:obj];
}


@end
