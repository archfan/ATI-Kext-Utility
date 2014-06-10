

#import "ValueToPresetTransformer2.h"
#import "ConnectorPreset.h"

/**
 This implementation is very unperformant but uses ConnectorPreset isEqualToValue:
 */
@implementation ValueToPresetTransformer2
- (id)initWithPresets:(NSArray *)presets
{
    return nil;
}

- (id)initWithPresets:(NSArray *)presets andFailSaveTransformer:(NSValueTransformer *)transformer
{
    self = [self initWithPresets:presets];
    
    if (self) {
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

- (id)findPresetForValue: (id)value {
    for(ConnectorPreset* preset in _presets)
        if([preset isEqualToValue:value])
            return preset;
    
    return nil;
}

- (id)findPresetForKey: (NSString*)key {
    for(ConnectorPreset* preset in _presets)
        if([preset.key isEqualToString:key])
            return preset;
    
    return nil;
}

/*!
 \param numeric value
 \returns value or preset key
 */
- (id)transformedValue:(id)value {
    id ret = [self findPresetForValue:value];
    
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
