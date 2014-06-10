

#import <Foundation/Foundation.h>

@interface ValueToPresetTransformer : NSValueTransformer
@property (readonly) NSValueTransformer* failSaveTransformer;
@property (readonly) NSDictionary* presets;

- (id)initWithPresets: (NSArray*)presets;
- (id)initWithPresets: (NSArray *)presets andFailSaveTransformer:(NSValueTransformer*)transformer;
@end
