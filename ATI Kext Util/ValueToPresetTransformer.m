
#import "ValueToPresetTransformer.h"
#import "ConnectorPreset.h"

@implementation ValueToPresetTransformer {
    NSDictionary* _reversePresets; //key -> preset.value, value -> preset.name
}
- (id)initWithPresets: (NSArray*)presets
{
    self = [self init];
    
    if(self) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:[presets count]];
        NSMutableDictionary* reverseDict = [[NSMutableDictionary alloc] initWithCapacity:[presets count]];
        
        
        for(ConnectorPreset* preset in presets) {
            if([preset respondsToSelector:@selector(value)]) {
                [dict setValue:preset forKey:[preset.value stringValue]];
                [reverseDict setValue:[preset value] forKey:[preset key]];
            }
        }
        
        _presets = dict;
        _reversePresets = reverseDict;
    }
    
    return self;
}

- (id)initWithPresets: (NSArray *)presets andFailSaveTransformer:(NSValueTransformer*)transformer
{
    self = [self initWithPresets:presets];
    
    if(self) {
        _failSaveTransformer = transformer;
    }
    
    return self;
}

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

/*!
 \param preset name
 \returns value
 */
- (id)reverseTransformedValue:(id)value
{
    id ret = [_reversePresets objectForKey:value];
    
    if(ret == nil) {
        if(_failSaveTransformer != nil)
            ret = [_failSaveTransformer reverseTransformedValue:value];
        else
            ret = value;
    }
    
    return ret;
}


/*!
 \param numeric value
 \returns value or key
 */
- (id)transformedValue:(id)value {
    id ret = [_presets objectForKey:[value stringValue]];
    
    if(ret == nil) {
        if(_failSaveTransformer != nil)
            ret = [_failSaveTransformer transformedValue:value];
        else
            ret = value;
    } else {
        ret = [ret key];
    }
    
    return ret;
}
@end
