//
//  ATModuleProtocol.h
//  ATModuleManager
//
//  Created by huluobo on 2019/1/29.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATModuleProtocol <UIApplicationDelegate>

@optional
+ (BOOL)singleton;

+ (id)shareInstance;

@end
