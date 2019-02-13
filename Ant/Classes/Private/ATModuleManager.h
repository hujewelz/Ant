//
//  ATModuleManager.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATModuleManager : NSObject

+ (nonnull instancetype)shareInstance;

/// Register a module with Module class.
+ (void)registerModule:(nullable Class)moduleClass;

/// Register a module with Module name.
+ (void)registerModuleName:(nonnull NSString *)moduleName;

+ (void)registerModuleFromPlistFile:(nullable NSString *)plist;

@end
