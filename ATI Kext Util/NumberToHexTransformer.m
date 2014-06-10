
#import "NumberToHexTransformer.h"

@implementation NumberToHexTransformer
+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}


/*!
 \param number
 \returns hex
 */
- (id)transformedValue:(id)value {
    return [NSString stringWithFormat:@"%x", [value intValue]];
}

/*!
 \param value hex value
 \returns NSNumber
 */
- (id)reverseTransformedValue:(id)value {
    NSScanner* scanner = [NSScanner scannerWithString:value];
    unsigned int iValue;
    
    [scanner scanHexInt:&iValue];
    
    return [NSNumber numberWithInt:iValue];
}
@end
