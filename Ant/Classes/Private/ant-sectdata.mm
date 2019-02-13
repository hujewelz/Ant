//
//  ant-sectdata.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#import "ant-sectdata.h"
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import "ATModuleManager.h"
#import "ATServiceManager.h"
#import "ATExport.h"

static void dyld_add_image_callback(const struct mach_header *mhp, intptr_t vmaddr_slide);

static __attribute__((constructor))
void ant_init() {
    _dyld_register_func_for_add_image(dyld_add_image_callback);
}

template <typename T>
T* getDataSection(const struct mach_header_64 *mhp, const char *sectname, size_t *outCount)
{
    unsigned long byteCount = 0;
    T* data = (T*)getsectiondata(mhp, "__DATA", sectname, &byteCount);
    if (outCount) *outCount = byteCount / sizeof(T);
    return data;
}

#define GETSECT(name, type, sectname)                            \
type *name(const struct mach_header_64 *mhp, size_t *outCount) { \
    return getDataSection<type>(mhp, sectname, outCount);        \
}

//      function name                  content type  section name
GETSECT(_getRegisteredModules,         module_t,     "__ant_modules");
GETSECT(_getRegisteredServiceInfoList, serviceinfo_t, "__ant_services")

#define ANT_STRING_FROM_CString(cstring) [NSString stringWithUTF8String: (cstring)]

static void add_module(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    size_t count = 0;
    struct mach_header_64 *_mhp = (struct mach_header_64 *)mhp;
    module_t *ms = _getRegisteredModules(_mhp, &count);
    for (size_t i=0; i<count; i++) {
        module_t m = ms[i];
        [ATModuleManager registerModuleName:ANT_STRING_FROM_CString(m)];
    }
}

static void add_services(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    size_t count = 0;
    struct mach_header_64 *_mhp = (struct mach_header_64 *)mhp;
    serviceinfo_t *infos = _getRegisteredServiceInfoList(_mhp, &count);
    for (size_t i=0; i<count; i++) {
        serviceinfo_t info = infos[i];
        [ATServiceManager registerServiceName:ANT_STRING_FROM_CString(info.cls) forServiceType:ANT_STRING_FROM_CString(info.prt)];
    }
}

static void dyld_add_image_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    add_module(mhp, vmaddr_slide);
    add_services(mhp, vmaddr_slide);
}
