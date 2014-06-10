

#import "RadeonBios.h"
#import "radeon_bios_decode.h"


@implementation RadeonBios
//- (id)init
//{
//    self = [super init];
//    
//    if(!self)
//        return self;
//    
//    [self add]
//    
//    return self;
//}

- (id)initWithBios:(NSString *)path error:(NSError *__autoreleasing *)error
{
    self = [super init];
    
    if(!self)
        return self;
        
    BOOL success = radeon_bios_decode_wrapper(self, path, error);
    
    if(!success)
        return nil;
    
    return self;
}

- (void)updateIoPciMatch
{
    int devId_int = [_deviceId intValue] & 0xFFFF;
    int venId_int = [_vendorId intValue] & 0xFFFF;
    
    int res = devId_int << 16;
    res += venId_int;
    
    _ioPciMatch = [NSNumber numberWithInt:res];
}

- (void)setDeviceId:(NSNumber *)deviceId
{
    _deviceId = deviceId;
    
    [self updateIoPciMatch];
}

- (void)setVendorId:(NSNumber *)vendorId
{
    _vendorId = vendorId;
    
    [self updateIoPciMatch];
}
@end
