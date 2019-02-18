//
//  SomeProtocolImpl.m
//  Module1
//
//  Created by huluobo on 2019/2/13.
//  Copyright © 2019 huluobo. All rights reserved.
//

#import "TestServiceImpl.h"
#import <Ant/Ant.h>
#import <PublicServices/PublicServices.h>

ANT_REGISTER_SERVICE(TestServiceImpl, TestService)
ANT_REGISTER_SERVICE(TestServiceImpl2, TestService2)
ANT_REGISTER_SERVICE(TestServiceImpl3, TestService3)
@interface TestServiceImpl() <TestService> @end

@implementation TestServiceImpl

- (void)service1 {
    NSLog(@"Service test from Impl");
}

@end
