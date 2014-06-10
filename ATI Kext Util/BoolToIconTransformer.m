
#import "BoolToIconTransformer.h"

@implementation BoolToIconTransformer

- (id)initWithYesImage: (NSImage*)yesImage andNoImage: (NSImage*)noImage
{
    self = [self init];
    
    if (self) {
        _yesImage = yesImage;
        _noImage = noImage;
    }
    
    return self;
}

+ (Class)transformedValueClass {
    return [NSImage class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}


/*!
 \param BOOL
 \returns image
 */
- (id)transformedValue:(id)value {
    return [value boolValue] == YES ? _yesImage : _noImage;
}

@end
