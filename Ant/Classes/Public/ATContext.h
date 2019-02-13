//
//  ATContext.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATContext : NSObject

+ (nonnull instancetype)shareInstance;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, copy, nonnull) NSString *plistName;

@end
