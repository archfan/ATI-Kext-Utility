

#import "ConnectorPreset.h"

@implementation ConnectorPreset
- (NSString*)description
{
    return [NSString stringWithFormat:@"%@ (%02x)", _key, [_value intValue]];
}

- (BOOL)isEqualToValue: (NSNumber*)value
{
    NSInteger maskedValue = [_value integerValue] & _mask;
    
    return [value integerValue] == maskedValue;
}

+ (id)connectorWithValue: (NSNumber*)value andKey: (NSString*) key andEqualMask: (NSInteger)mask
{
    ConnectorPreset* pair = [[ConnectorPreset alloc] init];
    
    [pair setValue:value];
    [pair setKey:key];
    [pair setMask:mask];
    
    return pair;
}

+ (id)withValue: (NSNumber*)value andKey: (NSString*) key
{
    ConnectorPreset* pair = [[ConnectorPreset alloc] init];
    
    [pair setValue:value];
    [pair setKey:key];
    [pair setMask:INT_MAX];
    
    return pair;
}
@end
