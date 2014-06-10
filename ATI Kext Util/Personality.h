
#import <Foundation/Foundation.h>

@interface Personality : NSObject
@property NSInteger offset;
@property NSString* name;
@property NSInteger expectedConnectorCount;
@property NSArray* connectors;

- (id)initWithName: (NSString*)name;
@end
