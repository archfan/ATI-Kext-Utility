

#import "Connector2.h"

@implementation Connector2

- (id)initWithData:(NSData*)data
{
    self = [self init];
    
    if(!self)
        return self;
    
    //init
    uint32_t connectorType;
    uint32_t controlFlags;
    uint16_t features;
    uint16_t unkown;
    uint8_t transmitter;
    uint8_t encoder;
    uint8_t hotplugId;
    uint8_t senseId;
    
    NSRange range = NSMakeRange(0, 0);
    
    //read
    [self readNext:data withRange:&range andLength:sizeof(connectorType) intoDestination:&connectorType];
    [self readNext:data withRange:&range andLength:sizeof(controlFlags) intoDestination:&controlFlags];
    [self readNext:data withRange:&range andLength:sizeof(features) intoDestination:&features];
    [self readNext:data withRange:&range andLength:sizeof(unkown) intoDestination:&unkown];
    [self readNext:data withRange:&range andLength:sizeof(transmitter) intoDestination:&transmitter];
    [self readNext:data withRange:&range andLength:sizeof(encoder) intoDestination:&encoder];
    [self readNext:data withRange:&range andLength:sizeof(hotplugId) intoDestination:&hotplugId];
    [self readNext:data withRange:&range andLength:sizeof(senseId) intoDestination:&senseId];
    
    //set fields
    _connectorType = [NSNumber numberWithInt:connectorType];
    _controlFlags = [NSNumber numberWithInt:controlFlags];
    _features = [NSNumber numberWithInt:features];
    _unkown = [NSNumber numberWithInt:unkown];
    _transmitter = [NSNumber numberWithInt:transmitter];
    [self setEncoder:[NSNumber numberWithInt:encoder]];
    _hotplugId = [NSNumber numberWithInt:hotplugId];
    _senseId = [NSNumber numberWithInt:senseId];
    
    return self;
}

- (void)readNext: (NSData*)data withRange: (NSRange*)range andLength: (NSInteger)length intoDestination: (void*)destination
{
    *range = NSMakeRange(range->location + range->length, length);
    
    [data getBytes:destination range:*range];
}

- (NSNumber*)features1
{
    //return only first byte
    return [NSNumber numberWithInteger:[_features integerValue] & 0xFF];
}

- (void)setFeatures1: (NSNumber*)number
{
    //set only first byte
    NSInteger numberInt = [number integerValue];
    NSInteger featuresInt = [_features integerValue];
    
    int featuresMask = INT16_MAX ^ 0xFF; //everything but first byte
    int numbersMask = 0xFF;
    
    //(featuresInt & featuresMask) -> reset first byte
    // | numberInt -> set numberInt
    featuresInt = (featuresInt & featuresMask) | (numberInt & numbersMask);
    
    _features = [NSNumber numberWithInteger:featuresInt];
}
- (NSNumber*)features2
{
    //return only second byte
    NSInteger intValue = [_features integerValue] >> 0x8;
    
    return [NSNumber numberWithInteger:intValue];
}
- (void)setFeatures2: (NSNumber*)number
{
    //set only second byte
    NSInteger numberInt = [number integerValue];
    NSInteger featuresInt = [_features integerValue];
    
    int featuresMask = 0xFF;
    int numberMask = 0xFF;
    
    featuresInt &= featuresMask; //clear but first byte
    numberInt = (numberInt & numberMask) << 0x8; //bitshift to second byte position
    
    featuresInt |= numberInt;
    
    _features = [NSNumber numberWithInteger:featuresInt];
}

/*
 @property NSNumber* encoder1;
 @property NSNumber* encoder2;
 
 - (NSNumber*)getEncoder;
 - (void)setEncoder:(NSNumber*)number;
 */

- (NSNumber*)encoder
{
    int digital = [_encoderDigital intValue];
    int analog = [_encoderAnalog intValue];
    
    int ret = analog << 0x4;
    
    ret |= digital;
    
    return [NSNumber numberWithInt:ret];
}

- (void)setEncoder:(NSNumber*)number
{
    int encoder = [number intValue] & INT8_MAX;
    int digitalMask = 0xF;
    
    int digital = encoder & digitalMask;
    int analog = encoder >> 0x4;
    
    _encoderAnalog = [NSNumber numberWithInt:analog];
    _encoderDigital = [NSNumber numberWithInt:digital];
}

+ (NSArray*)connectorsWithData:(NSData*)data count:(NSInteger)count
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < [self dataLength] * count; i += [self dataLength]) {
        NSRange range = NSMakeRange(i, [self dataLength]);
        
        Connector2* connector = [[Connector2 alloc]
                                initWithData:[data subdataWithRange:range]
                                ];
        
        [array addObject:connector];
    }
    
    return array;
}

+ (NSInteger)dataLength
{
    return sizeof(uint32_t) * 2 + sizeof(uint16_t) * 2 + sizeof(uint8_t) * 4;
}

- (NSData*)data
{
    uint32_t connectorType = [_connectorType intValue];
    uint32_t controlFlags = [_controlFlags intValue];
    uint16_t features = [_features intValue];
    uint16_t unkown = [_unkown intValue];
    uint8_t transmitter = [_transmitter intValue];
    uint8_t encoder = [[self encoder] intValue];
    uint8_t hotplugId = [_hotplugId intValue];
    uint8_t senseId = [_senseId intValue];
    
    
    NSMutableData* data = [NSMutableData dataWithCapacity:1000];
    
    [data appendBytes:&connectorType length:sizeof(connectorType)];
    [data appendBytes:&controlFlags length:sizeof(controlFlags)];
    [data appendBytes:&features length:sizeof(features)];
    [data appendBytes:&unkown length:sizeof(unkown)];
    [data appendBytes:&transmitter length:sizeof(transmitter)];
    [data appendBytes:&encoder length:sizeof(encoder)];
    [data appendBytes:&hotplugId length:sizeof(hotplugId)];
    [data appendBytes:&senseId length:sizeof(senseId)];
    
    return data;
}
@end
