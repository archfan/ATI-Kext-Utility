

#import <Foundation/Foundation.h>

@interface ValueToPresetTransformer2 : NSValueTransformer
@property (readonly) NSValueTransformer* failSaveTransformer;
@property (readonly) NSArray* presets;

- (id)initWithPresets: (NSArray*)presets;
- (id)initWithPresets: (NSArray *)presets andFailSaveTransformer:(NSValueTransformer*)transformer;
@end
