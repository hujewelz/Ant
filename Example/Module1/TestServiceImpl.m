//
//  SomeProtocolImpl.m
//  Module1
//
//  Created by huluobo on 2019/2/13.
//  Copyright © 2019 huluobo. All rights reserved.
//

#import "TestServiceImpl.h"
#import <Ant/Ant.h>

ANT_REGISTER_SERVICE(TestServiceImpl, TestService)
@implementation TestServiceImpl

- (void)test {
    NSLog(@"Service test from Impl");
}

@end
