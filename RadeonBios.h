

#import <Foundation/Foundation.h>

@interface RadeonBios : NSObject
@property NSNumber* subsystemVendorId;
@property NSNumber* subsystemId;
@property NSNumber* ioBaseAddress;
@property NSString* filename;
@property NSString* biosBootupMessage;
@property (nonatomic) NSNumber* vendorId;
@property (nonatomic) NSNumber* deviceId;
@property NSArray* connectors;
@property (readonly) NSNumber* ioPciMatch;

- initWithBios: (NSString*)path error: (NSError**)error;
@end
