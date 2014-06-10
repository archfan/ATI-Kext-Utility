

#import <Foundation/Foundation.h>

@interface Connector2 : NSObject
@property NSNumber* connectorType;
@property NSNumber* controlFlags;
@property NSNumber* features;
@property NSNumber* unkown;
@property NSNumber* transmitter;
@property NSNumber* encoderDigital;
@property NSNumber* encoderAnalog;
@property NSNumber* encoder;
@property NSNumber* hotplugId;
@property NSNumber* senseId;

+ (NSArray*)connectorsWithData:(NSData*)data count:(NSInteger)count;
- (id)initWithData:(NSData*)data;
- (NSData*)data;
+ (NSInteger)dataLength;

- (NSNumber*)features1;
- (void)setFeatures1: (NSNumber*)number;
- (NSNumber*)features2;
- (void)setFeatures2: (NSNumber*)number;
//
//- (NSNumber*)encoder;
//- (void)setEncoder:(NSNumber*)number;
@end
