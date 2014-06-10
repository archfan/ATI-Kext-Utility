
#import <Foundation/Foundation.h>
#import "Kext.h"

@interface Driver : NSObject
@property (readonly) NSArray* personalities;
@property (readonly) NSString* toolVersion;

- initWithKext: (Kext*)kext andAtiPersonalityTool: (NSString*)toolPath;
- (BOOL)patchExecutable: (NSString*)path error:(NSError**)error;
@end
