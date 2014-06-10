

#import "AppDelegate.h"
#import "NumberToHexTransformer.h"
#import "PathToFileTypeIconTransformer.h"
#import "StringExploderTransformer.h"
#import "BoolToIconTransformer.h"
#import "ValueToPresetTransformer.h"
#import "StringFormatTransformer.h"
#import "ConnectorPresets.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

+ (BoolToIconTransformer*)newStatusIconTransformer
{
    NSImage* yes = [[NSImage alloc] initWithContentsOfFile:@"/System/Library/Frameworks/IMCore.framework/Resources/status-available_flat.tiff"];
    NSImage* no = [[NSImage alloc] initWithContentsOfFile:@"/System/Library/Frameworks/IMCore.framework/Resources/status-away_flat.tiff"];
    
    BoolToIconTransformer* statusTransformer = [[BoolToIconTransformer alloc] initWithYesImage:yes andNoImage:no];
     
    return statusTransformer;
}

+ (StringFormatTransformer*)newPresetTransformer
{
    StringFormatTransformer* transformer = [[StringFormatTransformer alloc] initWithFormatString:@"%2x (%@)" andParameterKeyPaths:@[@"value", @"key"]];
    
    return transformer;
}

+ (void)initializePresetTransformer
{
    ConnectorPresets* presets = [ConnectorPresets sharedConnectorPresets];
    
    NumberToHexTransformer* failSave = [[NumberToHexTransformer alloc] init];
    
    ValueToPresetTransformer* connectorTypeTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.connectorTypes andFailSaveTransformer:failSave];
    ValueToPresetTransformer* controlFlagsTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.controlFlags andFailSaveTransformer:failSave];
    ValueToPresetTransformer* encodersAnalogTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.encodersAnalog andFailSaveTransformer:failSave];
    ValueToPresetTransformer* encodersDigitalTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.encodersDigital andFailSaveTransformer:failSave];
    
    ValueToPresetTransformer* featuresTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.features andFailSaveTransformer:failSave];
    ValueToPresetTransformer* transmittersTransformer = [[ValueToPresetTransformer alloc] initWithPresets:presets.transmitters andFailSaveTransformer:failSave];
    
    [NSValueTransformer setValueTransformer:connectorTypeTransformer forName:@"ConnectorTypePresetTransformer"];
    [NSValueTransformer setValueTransformer:controlFlagsTransformer forName:@"ControlFlagsPresetTransformer"];
    [NSValueTransformer setValueTransformer:encodersAnalogTransformer forName:@"EncoderAnalogPresetTransformer"];
    [NSValueTransformer setValueTransformer:encodersDigitalTransformer forName:@"EncoderDigitalPresetTransformer"];
    
    [NSValueTransformer setValueTransformer:featuresTransformer forName:@"FeaturesPresetTransformer"];
    [NSValueTransformer setValueTransformer:transmittersTransformer forName:@"TransmittersPresetTransformer"];
    
}

+ (void)initializeValueTransformer
{
    NumberToHexTransformer* numberTransformer = [[NumberToHexTransformer alloc] init];
    PathToFileTypeIconTransformer* pathTransformer = [[PathToFileTypeIconTransformer alloc] init];
    StringExploderTransformer* blankExploder = [[StringExploderTransformer alloc] initWithSeperator:@" "];
    BoolToIconTransformer* statusTransformer = [self newStatusIconTransformer];
    StringFormatTransformer* presetTransformer = [self newPresetTransformer];
    
    [NSValueTransformer setValueTransformer:numberTransformer forName:@"NumberToHexTransformer"];
    [NSValueTransformer setValueTransformer:pathTransformer forName:@"PathToFileTypeIconTransformer"];
    [NSValueTransformer setValueTransformer:blankExploder forName:@"BlankExploderTransformer"];
    [NSValueTransformer setValueTransformer:statusTransformer forName:@"StatusIconTransformer"];
    [NSValueTransformer setValueTransformer:presetTransformer forName:@"PresetTransformer"];
    
    [self initializePresetTransformer];
}
//
//- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename
//{
//    return YES;
//}

+ (void)initialize
{
    if(self == [AppDelegate class]) {
        [self initializeValueTransformer];
    }
}


@end
