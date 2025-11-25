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

#import "ido_protocol_public_interface.h"
#import "vbus_evt_app.h"
#import "include_help.h"

FOUNDATION_EXPORT double protocol_cVersionNumber;
FOUNDATION_EXPORT const unsigned char protocol_cVersionString[];

