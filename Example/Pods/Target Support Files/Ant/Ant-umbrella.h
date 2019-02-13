#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Ant.h"
#import "ATContext.h"
#import "ATExport.h"
#import "ATModuleProtocol.h"
#import "ATServiceProtocol.h"

FOUNDATION_EXPORT double AntVersionNumber;
FOUNDATION_EXPORT const unsigned char AntVersionString[];

