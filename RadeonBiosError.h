

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString* const RadeonBiosErrorDomain;

enum {
    RBAtomRomHeaderExtendsBeyondBiosImage = 900,
    RBNoAtomSignature,
    RBRomHeaderInvalid,
    RBAtomDataTableOutsideBios,
    RBAtomCommandTableOutsideBios,
    RBROMMasterTableInvalid
};