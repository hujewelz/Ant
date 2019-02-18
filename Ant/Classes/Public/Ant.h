//
//  Ant.h
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

#import <UIKit/UIKit.h>
#import "ATExport.h"
#import "ATModuleProtocol.h"
#import "ATServiceProtocol.h"

@interface Ant : NSObject <UIApplicationDelegate> 

+ (nonnull instancetype)shareInstance;

- (instancetype)init NS_UNAVAILABLE;

/// Register a module with Module class.
+ (void)registerModule:(nonnull Class)moduleClass;

/// Register a module with Module name.
+ (void)registerModuleWithName:(nonnull NSString *)moduleName;

+ (void)registerModulesFromPlistFile:(nullable NSString *)plist;

+ (void)registerService:(nonnull Class)service forProtocol:(nonnull Protocol *)protocol;

+ (id)serviceImplFromProtocol:(nonnull Protocol *)protocol;


@end
