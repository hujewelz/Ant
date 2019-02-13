//
//  ATServiceManager.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "ATServiceManager.h"

static NSMutableDictionary<NSString *, NSString *> *classMap;

NS_INLINE void setupMapsIfNeeded()
{
    if (!classMap) classMap = [NSMutableDictionary dictionary];
}

@implementation ATServiceManager

+ (id)service:(Protocol *)serviceType {
    NSParameterAssert(serviceType);
    setupMapsIfNeeded();
    NSString *prto = NSStringFromProtocol(serviceType);
    NSString *ser = classMap[prto];
    if (!ser) {
        return nil;
    }
    Class cls = NSClassFromString(ser);
    if (!cls) {
        return nil;
    }
    return [cls new];
}

+ (void)registerServiceName:(NSString *)service forServiceType:(NSString *)serviceType {
    Class cls = NSClassFromString(service);
    Protocol *prot = NSProtocolFromString(serviceType);
    [self registerService:cls forServiceType:prot];
}

+ (void)registerService:(Class)service forServiceType:(Protocol *)serviceType {
    if (!service) {
        return;
    }
    if (!serviceType) {
        return;
    }
    setupMapsIfNeeded();
    if (![service conformsToProtocol:serviceType]) {
        return;
    }
    NSString *ser = NSStringFromClass(service);
    NSString *prto = NSStringFromProtocol(serviceType);
    classMap[prto] = ser;
}

@end
