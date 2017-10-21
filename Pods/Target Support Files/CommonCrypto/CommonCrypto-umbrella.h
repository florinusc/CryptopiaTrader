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

#import "NSData+CommonCrypto.h"

FOUNDATION_EXPORT double CommonCryptoVersionNumber;
FOUNDATION_EXPORT const unsigned char CommonCryptoVersionString[];

