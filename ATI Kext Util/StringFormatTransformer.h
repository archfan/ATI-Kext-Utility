

#import <Foundation/Foundation.h>

@interface StringFormatTransformer : NSValueTransformer
@property (readonly) NSString* formatString;
@property (readonly) NSArray* keyPaths;

- (id)initWithFormatString: (NSString*)formatString andParameterKeyPaths: (NSArray*)keyPaths;

@end
