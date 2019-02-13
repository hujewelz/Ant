//
//  ATContext.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "ATContext.h"

@implementation ATContext

+ (nonnull instancetype)shareInstance {
    static ATContext *ctx = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ctx = [[self class] new];
        ctx.plistName = @"Info";
    });
    return ctx;
}


@end
