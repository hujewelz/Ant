//
//  ATServiceManager.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "ATServiceManager.h"
#include<pthread.h>

static NSMutableDictionary<NSString *, NSString *> *classMap;

static pthread_mutex_t lock;

NS_INLINE void setupMapsIfNeeded()
{
    if (!classMap) classMap = [NSMutableDictionary dictionary];
}

@implementation ATServiceManager

+ (void)initialize {
    pthread_mutex_init(&lock, NULL);
}

+ (id)serviceImplFromeService:(Protocol *)service {
    NSParameterAssert(service);
    setupMapsIfNeeded();
    NSString *prto = NSStringFromProtocol(service);
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
    pthread_mutex_lock(&lock);
    classMap[prto] = ser;
    pthread_mutex_unlock(&lock);
}

@end
