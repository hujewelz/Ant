//
//  ATExport.h
//  ModuleManager
//
//  Created by huluobo on 2019/1/30.
//  Copyright © 2019 jewelz. All rights reserved.
//

#ifndef ATExport_h
#define ATExport_h

struct serviceinfo_t {
    const char *cls;
    const char *prt;
};

#define ANT_MODULE_EXPORT(name) char * k##name##mod SECTION_DATA(__ant_modules) = ""#name"";

#define ANT_REGISTER_SERVICE(imp, protocol) struct serviceinfo_t k##imp##_##protocol SECTION_DATA(__ant_services) = {#imp, #protocol};

#define SECTION_DATA(sectname) __attribute((used, section("__DATA, "#sectname" ")))


#endif /* ATExport_h */

