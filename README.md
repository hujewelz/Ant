# Ant

[![CI Status](https://img.shields.io/travis/huluobo/Ant.svg?style=flat)](https://travis-ci.org/huluobo/Ant)
[![Version](https://img.shields.io/cocoapods/v/Ant.svg?style=flat)](https://cocoapods.org/pods/Ant)
[![License](https://img.shields.io/cocoapods/l/Ant.svg?style=flat)](https://cocoapods.org/pods/Ant)
[![Platform](https://img.shields.io/cocoapods/p/Ant.svg?style=flat)](https://cocoapods.org/pods/Ant)

## 概述
Ant 是用于 iOS 应用组件化实现方案。使用了协议注册的方式来实现组件解耦。
作者在 [本文](http://jewelz.me/cjs77iaoc001z8is6421dnuyc/) 中对组件化解耦方案做了简单的分析。

### 组件生命周期管理

Ant 为组件提供了完整的生命周期方法，用于与宿主项目进行必要的通信。目前只包含 UIApplicationDelegate 中的所有方法。

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[Ant shareInstance] application:application didFinishLaunchingWithOptions:launchOptions];
return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[Ant shareInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[Ant shareInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[Ant shareInstance] applicationWillEnterForeground:application];
}
```
所有注册的组件(模块)会在 AppDelegate 相应的生命周期方法调用时自动调用。

#### 模块注册

模块注册有动态注册和静态注册两种。

##### 静态注册

可以使用以下接口来静态注册模块：

```objc
/// Register a module with Module class.
+ (void)registerModule:(nonnull Class)moduleClass;

/// Register a module with Module name.
+ (void)registerModuleWithName:(nonnull NSString *)moduleName;

+ (void)registerModulesFromPlistFile:(nullable NSString *)plist;
```

你可以在 Info.plist 中添加 Modules：

![Info.plist](https://github.com/hujewelz/Ant/blob/master/medias/infoplist.png)

可以在调用 `registerModulesFromPlistFile` 并传入 `nil` ，Ant 会默认加载 Info.plist 中的 Modules：
```objc
[Ant registerModulesFromPlistFile: nil];
```

##### 动态注册

可以在任何位置使用 `ANT_MODULE_EXPORT(name)` 宏定义来注册模块。

```objc
ANT_MODULE_EXPORT(Module1App)

@interface Module1App() <ATModuleProtocol> {
    NSInteger state;
}

@end
```

### 组件通信

Ant 使用协议注册的方式（Protocol-Class）来实现组件通信。
Protocol-Class 方案就是通过 protocol 定义服务接口，服务提供方通过实现该接口来提供接口定义的服务。具体实现就是把 protocol 和 class 做一个映射，同时在内存中保存一张映射表，使用的时候，就通过 protocol 找到对应的 class 来获取需要的服务。

**示例图：**
![protocol-class使用示例图](https://github.com/hujewelz/Ant/blob/master/medias/protocol-class.jpg)
**示例代码：**
```objc
// TestService.h (定义服务)
@protocol TestService <NSObject>
/// 测试
- (void)service1;

@end

// 组件 A (服务提供方)
ANT_REGISTER_SERVICE(TestServiceImpl, TestService)
@interface TestServiceImpl() <TestService> @end

@implementation TestServiceImpl

- (void)service1 {
    NSLog(@"Service test from Impl");
}

@end

// 组件 B (服务使用方)
id <TestService> obj = [Ant serviceImplFromProtocol:@protocol(TestService)];
[obj service1];
```
服务的注册和组件的注册一样，有动态注册和静态注册两种。
动态注册使用 `ANT_REGISTER_SERVICE(impl, protocol)` 宏定义来注册实现类和遵守的协议。

```objc
ANT_REGISTER_SERVICE(TestServiceImpl, TestService)
@interface TestServiceImpl() <TestService> @end
```
也可以使用 `registerService:forProtocol:` 方法来手动注册。

## 安装

Ant 可以使用 [CocoaPods](https://cocoapods.org) 进行安装。

```ruby
pod 'Ant'
```

## 作者

[huluobo](http://jewelz.me), hujewelz@163.com

## License

Ant is available under the MIT license. See the LICENSE file for more info.
