

#import "StringExploderTransformer.h"

@implementation StringExploderTransformer
- (id)initWithSeperator: (NSString*)seperator
{
    self = [self init];
    
    if(self) {
        _seperator = seperator;
    }
    
    return self;
}

+ (Class)transformedValueClass {
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}


/*!
 \param string
 \returns array
 */
- (id)transformedValue:(id)value {
    if([value respondsToSelector:@selector(componentsSeparatedByString:)])
        return [value componentsSeparatedByString:_seperator];
    else
        return nil;
}

/*!
 \param array
 \returns string
 */
- (id)reverseTransformedValue:(id)value {
    return [value componentsJoinedByString:_seperator];
}

@end
