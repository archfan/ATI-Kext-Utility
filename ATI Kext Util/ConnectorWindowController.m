
#import "ConnectorWindowController.h"
#import "ConnectorPresets.h"
#import "Connector2.h"

@implementation ConnectorWindowController {
    NSValueTransformer* numberHexTransformer;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        numberHexTransformer = [NSValueTransformer valueTransformerForName:@"NumberToHexTransformer"];
        //_connectorTypePresetSelection = _featuresPresetSelection = _transmitterPresetSelection = _unkownPresetSelection = _encoderPresetSelection = _hotplugIdPresetSelection = _senseIdPresetSelection = @"xxxxx";
    }
    return self;
}
- (void)windowDidLoad
{
    [super windowDidLoad];
    
}

- (IBAction)blaButtonClick:(id)sender
{
    Connector2* connector = [self connector];
    
    NSData* data = [connector data];
    const uint8_t* bytes = [data bytes];
    
    NSMutableString* string = [[NSMutableString alloc] init];
    
    for(int i = 0; i < [data length]; i++)
        [string appendFormat:@"%02hhx ", bytes[i]];
    
    NSLog(@"%@", string);
}

- (Connector2*)connector
{
    Connector2* cnctor = [[Connector2 alloc] init];
//    
//    [cnctor setConnectorTypeWithNumber:[self numberFromTextField:_connectorTypeTextField]];
//    [cnctor setControlFlagsWithNumber:[self numberFromTextField:_controlFlagsTextField]];
//    [cnctor setFeaturesWithNumber:[self numberFromTextField:_featuresTextField]];
//    [cnctor setTransmitterWithNumber:[self numberFromTextField:_transmitterTextField]];
//    [cnctor setUnkownWithNumber:[self numberFromTextField:_unkownTextField]];
//    [cnctor setEncoderWithNumber:[self numberFromTextField:_encoderTextField]];
//    [cnctor setHotplugIdWithNumber:[self numberFromTextField:_hotplugIdTextField]];
//    [cnctor setSenseIdWithNumber:[self numberFromTextField:_senseIdTextField]];
//    
//    
    return cnctor;
}

- (NSNumber*)numberFromTextField: (NSTextField*)textField
{
    return [numberHexTransformer reverseTransformedValue:[textField stringValue]];
}

//- (IBAction)presetPopupButtonChanged:(id)sender
//{
//    NSAlert* alert = [[NSAlert alloc] init];
//    
//    [alert runModal];
//}

- (void)setPreset:(ConnectorPreset*)preset inTextField:(NSTextField*)textField {
    if(![preset isKindOfClass:[ConnectorPreset class]])
        return;
    
    [textField setStringValue: [numberHexTransformer transformedValue:preset.value]];
}

- (IBAction)connectorTypePresetSelected:(NSPopUpButton *)sender {
    [self setPreset:_connectorTypePresetSelection inTextField:_connectorTypeTextField];
}

- (IBAction)featuresPresetSelected:(NSPopUpButton *)sender {
    [self setPreset:_featuresPresetSelection inTextField:_featuresTextField];
}

- (IBAction)transmitterPresetSelected:(NSPopUpButton *)sender {
    [self setPreset:_transmitterPresetSelection inTextField:_transmitterTextField];
}

- (IBAction)encoderPresetSelected:(NSPopUpButton *)sender {
    [self setPreset:_encoderPresetSelection inTextField:_encoderTextField];
}
@end
