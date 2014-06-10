

#import "Document.h"
#import "Driver.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
//        [self updateChangeCount:NSSaveOperation];
        
    }
    return self;
}

- (NSString*)windowNibName
{
//    return @"DocumentWindow";
    return @"DocumentWindow";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [_tableView bind:@"highlightedValues" toObject:self withKeyPath:@"self.vbios.ioPciMatch" options:nil];
}


- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{ //https://developer.apple.com/library/mac/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/AdvancedTopics/AdvancedTopics.html#//apple_ref/doc/uid/TP40011179-CH7-SW23
    BOOL readSuccess = NO;
    
    Kext* kext = [[Kext alloc] initWithURL:url error:outError];
    
    if (kext != nil) {
        readSuccess = YES;
        
        //set kext
        _kext = kext;
        
        //set driver
        NSString* atiPersonalityTool = [[NSBundle mainBundle] pathForResource:@"ati-personality" ofType:@"pl"];
        _driver = [[Driver alloc] initWithKext:_kext andAtiPersonalityTool:atiPersonalityTool];
    }
    
    return readSuccess;
}

- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    BOOL success = NO;
    Kext* destinationKext;
    
    //copy old file to url
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSURL* srcUrl = [NSURL fileURLWithPath:_kext.path isDirectory:YES];
    
    success = [fileManager copyItemAtURL:srcUrl toURL:url error:outError];
    
    if(!success)
        return success;

    
    //kext already copied ... load
    destinationKext = [[Kext alloc] initWithURL:url error:outError];
    success = destinationKext != nil;
    
    if(!success)
        return success;
    
    NSURL* dstExecutableUrl = [NSURL fileURLWithPath:_kext.executeable isDirectory:NO];
    
    //write kext stuff back
    success = [_kext writeToURL:dstExecutableUrl error:outError];
    
    if(!success)
        return success;

    
    //patch driver executable
    success = [_driver patchExecutable:[destinationKext executeable] error:outError];
    
    return success;
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

@synthesize vbios;

- (IBAction)loadBios:(id)sender {
    NSError* error;
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    
    if([openDlg runModal] != NSOKButton)
        return;
    
    NSURL* url = [openDlg URL];
    
    
    RadeonBios* newVbios = [[RadeonBios alloc] initWithBios:url.path error:&error];
    
    if(newVbios == nil) {
        NSLog(@"bios error: %@", error);
        return;
    }
    
    [self setVbios:newVbios];
    [self setVbiosLoaded:YES];
}

- (IBAction)doStuff:(id)sender {
    
    
    NSLog(@"%@", _driver);
}
@end
