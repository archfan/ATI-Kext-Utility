

#import "Personality.h"

@implementation Personality
- (id)init
{
    self = [super init];
    
    if(!self)
        return self;
    
    _connectors = [[NSArray alloc] init];
    
    return self;
}


- (id)initWithName: (NSString*)name
{
    self = [self init];
    
    if(!self)
        return self;
    
    _name = name;
    
    return self;
}


@end
