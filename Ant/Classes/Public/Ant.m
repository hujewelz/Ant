//
//  Ant.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/29.
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

+ (void)registerModuleWithName:(NSString *)moduleName {
    [ATModuleManager registerModuleWithName:moduleName];
}

+ (void)registerModulesFromPlistFile:(NSString *)plist {
    [ATModuleManager registerModulesFromPlistFile:plist];
}

+ (id)serviceImplFromProtocol:(Protocol *)protocol {
    return [ATServiceManager serviceImplFromProtocol:protocol];
}

+ (void)registerService:(Class)service forProtocol:(Protocol *)protocol {
    [ATServiceManager registerService:service forProtocol:protocol];
}



@end
