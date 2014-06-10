

#import <Foundation/Foundation.h>
#import "CWLSynthesizeSingleton.h"

@interface ConnectorPresets : NSObject
CWL_DECLARE_SINGLETON_FOR_CLASS(ConnectorPresets)

@property(copy) IBOutlet NSArray* connectorTypes;
@property(copy) IBOutlet NSArray* controlFlags;
@property(copy) IBOutlet NSArray* encodersAnalog;
@property(copy) IBOutlet NSArray* encodersDigital;
@property(copy) IBOutlet NSArray* features;
@property(copy) IBOutlet NSArray* transmitters;


@end
