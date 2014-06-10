

#import <Foundation/Foundation.h>

#define KEXT_INFO_PATH "Contents/Info.plist"
#define KEXT_EXEC_DIR "Contents/MacOS/"

/***\
 not muteable
 **/
@interface Kext : NSObject
@property(readonly) NSString* path;
@property(readonly) NSString* executeable;
@property(readonly) NSMutableDictionary* info;
@property(readonly) NSString* codeSignInfo;
@property(readonly) BOOL codeSigningOkay;
@property(readonly) BOOL loaded;

- (id)initWithPath: (NSString*)path error:(NSError**)error;
- (id)initWithURL: (NSURL*)url error:(NSError**)error;
- (BOOL)writeToURL: (NSURL*)url error:(NSError**)error;

- (BOOL)codeSigningOkay;

@end
