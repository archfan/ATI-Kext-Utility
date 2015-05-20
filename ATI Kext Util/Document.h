
#import <Cocoa/Cocoa.h>
#import "Kext.h"
#import "Driver.h"
#import "RadeonBios.h"

@interface Document : NSDocument
@property (readonly) Kext* kext;
@property (readonly) Driver* driver;
@property RadeonBios* vbios;
@property BOOL vbiosLoaded;
- (IBAction)doStuff:(id)sender;
- (IBAction)loadBios:(id)sender;
@end
