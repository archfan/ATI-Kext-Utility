

#import <Cocoa/Cocoa.h>
#import "ConnectorWindowController.h"

@interface MainWindowController : NSWindowController
@property (strong) IBOutlet NSString *kextPath;

- (IBAction)openConnectorWindow: (id)sender;
- (IBAction)openKextWindow:(id)sender;
- (IBAction)openPresetWindow: (id)sender;
@end
