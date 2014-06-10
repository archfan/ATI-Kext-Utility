

#import <Cocoa/Cocoa.h>
#import "ConnectorPreset.h"

@interface ConnectorWindowController : NSWindowController
@property (weak) IBOutlet NSTextField *connectorTypeTextField;
@property (weak) IBOutlet NSTextField *controlFlagsTextField;
@property (weak) IBOutlet NSTextField *featuresTextField;
@property (weak) IBOutlet NSTextField *transmitterTextField;
@property (weak) IBOutlet NSTextField *unkownTextField;
@property (weak) IBOutlet NSTextField *encoderTextField;
@property (weak) IBOutlet NSTextField *hotplugIdTextField;
@property (weak) IBOutlet NSTextField *senseIdTextField;
@property (weak) IBOutlet id connectorTypePresetSelection;
@property (weak) IBOutlet id featuresPresetSelection;
@property (weak) IBOutlet id transmitterPresetSelection;
@property (weak) IBOutlet id unkownPresetSelection;
@property (weak) IBOutlet id encoderPresetSelection;
@property (weak) IBOutlet id hotplugIdPresetSelection;
@property (weak) IBOutlet id senseIdPresetSelection;


- (IBAction)connectorTypePresetSelected:(NSPopUpButton *)sender;
- (IBAction)featuresPresetSelected:(NSPopUpButton *)sender;
- (IBAction)transmitterPresetSelected:(NSPopUpButton *)sender;
- (IBAction)encoderPresetSelected:(NSPopUpButton *)sender;

- (IBAction)blaButtonClick:(id)sender;


@end
