//
//  ATServiceManager.m
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

#import "ATServiceManager.h"
#include<pthread.h>

static NSMutableDictionary<NSString *, NSString *> *classMap;

static pthread_mutex_t lock;

#define TIME_BEGIN \
CFAbsoluteTime begin = CFAbsoluteTimeGetCurrent();

#define TIME_END \
CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();\
printf("duration: %f\n", end - begin);


NS_INLINE void setupMapsIfNeeded()
{
    if (!classMap) classMap = [NSMutableDictionary dictionary];
}

NS_INLINE NSString *serviceForProtocol(Protocol *p) {
    __block NSString *cls = nil;
    NSString *prto = NSStringFromProtocol(p);
    pthread_mutex_lock(&lock);
    cls = classMap[prto];
    pthread_mutex_unlock(&lock);
    return cls;
}

@implementation ATServiceManager

+ (void)initialize {
    pthread_mutex_init(&lock, NULL);
}

+ (id)serviceImplFromProtocol:(Protocol *)protocol {
    NSParameterAssert(protocol);
    setupMapsIfNeeded();
    NSString *prto = NSStringFromProtocol(protocol);
    NSString *ser = serviceForProtocol(protocol);//classMap[prto];
    NSString *msg1 = [NSString stringWithFormat:@"Please register your class for protocol '%@' first.", prto];
    NSAssert(ser, msg1);

    Class cls = NSClassFromString(ser);
    NSString *msg2 = [NSString stringWithFormat:@"The Class '%@' does not exist.", ser];
    NSAssert(cls, msg2);
    
    NSString *msg3 = [NSString stringWithFormat:@"The Class '%@' does not conform to expected protocol '%@'", ser, prto];
    NSAssert([cls conformsToProtocol:protocol], msg3);
    return [[cls alloc] init];
}

+ (void)registerServiceName:(NSString *)service forServiceType:(NSString *)serviceType {
    Class cls = NSClassFromString(service);
    Protocol *prot = NSProtocolFromString(serviceType);
    [self registerService:cls forProtocol:prot];
}

+ (void)registerService:(Class)service forProtocol:(Protocol *)protocol {
    if (!service) {
        return;
    }
    if (!protocol) {
        return;
    }
    setupMapsIfNeeded();
    /*if (![service conformsToProtocol:protocol]) {
        return;
    }*/
    NSString *ser = NSStringFromClass(service);
    NSString *prto = NSStringFromProtocol(protocol);

    pthread_mutex_lock(&lock);
    classMap[prto] = ser;
    pthread_mutex_unlock(&lock);
}


@end
