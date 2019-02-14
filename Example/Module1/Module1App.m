//
//  Module1App.m
//  Module1
//
//  Created by huluobo on 2019/2/13.
//  Copyright © 2019 huluobo. All rights reserved.
//

#import "Module1App.h"
#import <Ant/Ant.h>

ANT_MODULE_EXPORT(Module1App)

@interface Module1App() <ATModuleProtocol> {
    NSInteger state;
}

@end

@implementation Module1App

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    state = 0;
    NSLog(@"Module A state: %zd", state);
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    state += 1;
    NSLog(@"Module A state: %zd", state);
}

@end
