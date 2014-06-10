

#import "StringFormatTransformer.h"
#import "NSString+NSArrayFormatExtension.h"

@implementation StringFormatTransformer


- (id)initWithFormatString: (NSString*)formatString andParameterKeyPaths:(NSArray *)keyPaths
{
    self = [super init];
    
    if(self) {
        _formatString = formatString;
        _keyPaths = keyPaths;
    }
    
    return self;
}

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return NO;
}
//
//- (id)reverseTransformedValue:(id)value
//{
//    
//}


/*!
 \param value
 \returns formatted string
 */
- (id)transformedValue:(id)object {
    NSMutableArray* keyPathValues = [[NSMutableArray alloc] initWithCapacity:[_keyPaths count]];
    
    for(NSString* keyPath in _keyPaths) {
        id value = [object valueForKeyPath:keyPath];
        [keyPathValues addObject:value];
    }
    
    return [NSString stringWithFormat:_formatString array:keyPathValues];
}
@end
