

#import <Foundation/Foundation.h>

@interface RadeonBiosConnector : NSObject
@property NSNumber* index;
@property NSString* type;
@property NSString* encoder;
@property NSNumber* transmitter;
@property NSNumber* i2cid;
@property NSNumber* osxSenseId;
@end
