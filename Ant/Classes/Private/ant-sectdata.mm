//
//  ant-sectdata.m
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
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
T* getDataSection(const struct mach_header *mhp, const char *sectname, size_t *outCount)
{
    
#ifndef __LP64__
    uint32_t byteCount = 0;
    T* data = (T*)getsectdatafromheader(mhp, "__DATA", sectname, &byteCount);
    if (outCount) *outCount = byteCount / sizeof(T);
#else
    unsigned long byteCount = 0;
    T* data = (T*)getsectiondata((struct mach_header_64 *)mhp, "__DATA", sectname, &byteCount);
    if (outCount) *outCount = byteCount / sizeof(T);
#endif
    return data;
}

#define GETSECT(name, type, sectname)                            \
type *name(const struct mach_header *mhp, size_t *outCount) { \
    return getDataSection<type>(mhp, sectname, outCount);        \
}

//      function name                  content type  section name
GETSECT(_getRegisteredModules,         module_t,     "__ant_modules");
GETSECT(_getRegisteredServiceInfoList, serviceinfo_t, "__ant_services")

#define ANT_STRING_FROM_CString(cstring) [NSString stringWithUTF8String: (cstring)]

static void add_module(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    size_t count = 0;
    module_t *ms = _getRegisteredModules(mhp, &count);
    for (size_t i=0; i<count; i++) {
        module_t m = ms[i];
//        [ATModuleManager registerModuleWithName:ANT_STRING_FROM_CString(m)];
        [ATModuleManager registerModuleWithNameLazily:ANT_STRING_FROM_CString(m)];
    }
}

static void add_services(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    size_t count = 0;
    serviceinfo_t *infos = _getRegisteredServiceInfoList(mhp, &count);
    for (size_t i=0; i<count; i++) {
        serviceinfo_t info = infos[i];
        [ATServiceManager registerServiceName:ANT_STRING_FROM_CString(info.cls) forServiceType:ANT_STRING_FROM_CString(info.prt)];
    }
}

static void dyld_add_image_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    add_module(mhp, vmaddr_slide);
    add_services(mhp, vmaddr_slide);
}
