
#import <Foundation/Foundation.h>

@interface ConnectorPreset : NSObject
@property NSString* key;
@property NSNumber* value;
@property NSInteger mask;

+ (id)withValue: (NSNumber*)value andKey: (NSString*) key;
+ (id)connectorWithValue: (NSNumber*)value andKey: (NSString*) key andEqualMask: (NSInteger)mask;
- (BOOL)isEqualToValue: (NSNumber*)value;
@end
