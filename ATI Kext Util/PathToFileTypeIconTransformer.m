

#import "PathToFileTypeIconTransformer.h"

@implementation PathToFileTypeIconTransformer
+ (Class)transformedValueClass {
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}


/*!
 \param path
 \returns icon
 */
- (id)transformedValue:(id)value {
    NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFile:value];
    
    return icon;
}

@end
