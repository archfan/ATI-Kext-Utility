
#import <Foundation/Foundation.h>

@interface BoolToIconTransformer : NSValueTransformer
@property (readonly) NSImage* yesImage;
@property (readonly) NSImage* noImage;

- (id)initWithYesImage: (NSImage*)yesImage andNoImage: (NSImage*)noImage;
@end
