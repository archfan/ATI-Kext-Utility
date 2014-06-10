

#import "MainWindowController.h"
#import "Driver.h"
#import "RadeonBios.h"

@implementation MainWindowController {
    ConnectorWindowController* connectorController;
    NSDocumentController* documentController;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _kextPath = @"/System/Library/Extensions/AMD4600Controller.kext";
        connectorController = [[ConnectorWindowController alloc] initWithWindowNibName:@"ConnectorWindow"];
        documentController = [NSDocumentController sharedDocumentController];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
}

- (IBAction)openKextWindow:(id)sender
{
//    kextController = [[KextWindowController alloc] initWithWindowNibName:@"KextWindow"];
//    [kextController setKextPath: _kextPath];
//    [kextController showWindow:self];
    
    void (^completionHandler)(NSDocument*, BOOL, NSError*)  =  ^(NSDocument* document, BOOL documentWasAlreadyOpen, NSError* error){
        NSLog(@"documentWasAlreadyOpen=%x, error=%@, document=%@", documentWasAlreadyOpen, error, document);
        
        if(error != nil)
            NSLog(@"%@", error);
        
        [document showWindows];
    };
    
    NSLog(@"trying to open document");
    NSURL* url = [NSURL fileURLWithPath:_kextPath];
    [documentController openDocumentWithContentsOfURL:url display:YES completionHandler:completionHandler];
    
}

- (IBAction)openPresetWindow:(id)sender
{
    static NSWindowController* controller;
    if(controller == nil) {
        controller = [[NSWindowController alloc] initWithWindowNibName:@"PresetWindow"];
    }
    
    [controller showWindow:self];
}

- (IBAction)openConnectorWindow: (id)sender
{
//    NSError* error;
//    NSString* biosPath = @"/Users/peter/Google Drive/Standrechner/PersonalityFMavericks/bios/1002_9498_9498174b.rom";
//    RadeonBios* radeonBios = [[RadeonBios alloc] initWithBios:biosPath error:&error];
    /*NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"hi"];
    [alert runModal];
    */
    
    //[connectorController showWindow:self];
    
//    Driver* driver = [[Driver alloc]
//                      initWithBinaryPath:@"/System/Library/Extensions/AMD4600Controller.kext/Contents/MacOS/AMD4600Controller"
//                      andAtiPersonalityTool:@"/Users/peter/Google Drive/Standrechner/PersonalityFMavericks/tools/ati-personality.pl.0.15/ati-personality.pl"];
//    
//    NSLog(@"%@", driver);
}


@end
