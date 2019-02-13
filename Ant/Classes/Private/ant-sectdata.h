//
//  ant-sectdata.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach-o/loader.h>

typedef struct serviceinfo_t serviceinfo_t;
typedef char * module_t;

extern module_t *_getRegisteredModules(const struct mach_header_64 *mhp, size_t *outCount);
extern serviceinfo_t *_getRegisteredServiceInfoList(const struct mach_header_64 *mhp, size_t *outCount);

