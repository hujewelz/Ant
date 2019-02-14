//
//  Ant.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/29.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "Ant.h"
#import "ATModuleManager.h"
#import "ATServiceManager.h"

@implementation Ant

+ (instancetype)shareInstance {
    static Ant *ant = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ant = [Ant new];
    });
    return ant;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *sel = NSStringFromSelector(aSelector);
    if ([sel rangeOfString:@"application"].location != NSNotFound) {
        return [ATModuleManager shareInstance];
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (void)registerModule:(Class)moduleClass {
    [ATModuleManager registerModule:moduleClass];
}

+ (void)registerModuleName:(NSString *)moduleName {
    [ATModuleManager registerModuleName:moduleName];
}

+ (void)registerModuleFromPlistFile:(NSString *)plist {
    [ATModuleManager registerModuleFromPlistFile:plist];
}

+ (id)serviceImplFromeService:(Protocol *)service {
    return [ATServiceManager serviceImplFromeService:service];
}

+ (void)registerService:(Class)service forServiceType:(Protocol *)serviceType {
    [ATServiceManager registerService:service forServiceType:serviceType];
}



@end
