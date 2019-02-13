//
//  Ant.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/29.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ant : NSObject <UIApplicationDelegate> 

+ (nonnull instancetype)shareInstance;

- (instancetype)init NS_UNAVAILABLE;

/// Register a module with Module class.
+ (void)registerModule:(nonnull Class)moduleClass;

/// Register a module with Module name.
+ (void)registerModuleName:(nonnull NSString *)moduleName;

+ (void)registerModuleFromPlistFile:(nullable NSString *)plist;

+ (void)registerService:(nonnull Class)service forServiceType:(nonnull Protocol *)serviceType;

+ (id)service:(nonnull Protocol *)serviceType;



@end
