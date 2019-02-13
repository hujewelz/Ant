//
//  ATModuleManager.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "ATModuleManager.h"
#import "ATModuleProtocol.h"

static NSMutableArray<id <ATModuleProtocol>> *modules;
static NSMutableSet<NSString *> *moduleNames;

static NSString * const kAntModuleKey = @"Modules";

NS_INLINE void setupModulesIfNeeded()
{
    if (!modules) modules = [NSMutableArray array];
    if (!moduleNames) moduleNames = [NSMutableSet set];
}

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

+ (void)registerModuleName:(NSString *)moduleName {
    NSParameterAssert(moduleName);
    Class cls = NSClassFromString(moduleName);
    [self registerModule:cls];
}

+ (void)registerModuleFromPlistFile:(NSString *)plist {
    
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
        [self registerModuleName:m];
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
    [modules enumerateObjectsUsingBlock:^(id<ATModuleProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:obj];
        }
    }];
}

#pragma mark - Private

+ (void)addNewModule:(Class)moduleClass {
    if (!moduleClass) {
        return;
    }
    if (![moduleClass conformsToProtocol: @protocol(ATModuleProtocol)]) {
        return;
    }
    setupModulesIfNeeded();
    
    NSString *mn = NSStringFromClass(moduleClass);
    if ([moduleNames containsObject:mn]) { // 防止重复注册
        return;
    }
    [moduleNames addObject:mn];
    id <ATModuleProtocol> obj = [self moduleInstanceWithModule:moduleClass];
    [modules addObject:obj];
}

+ (id <ATModuleProtocol>)moduleInstanceWithModule:(Class)moduleClass {
    if (![moduleClass.class respondsToSelector:@selector(singleton)]) {
        return [[moduleClass.class alloc] init];
    }
    if (![moduleClass.class respondsToSelector:@selector(shareInstance)]) {
        return [[moduleClass.class alloc] init];
    }
    return [[moduleClass class] shareInstance];
}

@end
