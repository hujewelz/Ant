//
//  ATServiceManager.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATServiceManager : NSObject

+ (void)registerService:(nullable Class)service forServiceType:(nullable Protocol *)serviceType;

+ (void)registerServiceName:(nonnull NSString*)service forServiceType:(nonnull NSString *)serviceType;

+ (nullable id)service:(nonnull Protocol *)serviceType;

@end
