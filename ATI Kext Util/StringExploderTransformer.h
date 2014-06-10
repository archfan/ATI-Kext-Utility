
#import <Foundation/Foundation.h>

@interface StringExploderTransformer : NSValueTransformer
@property (readonly) NSString* seperator;
- (id)initWithSeperator: (NSString*)seperator;
@end
