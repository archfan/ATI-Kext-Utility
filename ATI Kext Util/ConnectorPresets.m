
#import "ConnectorPresets.h"
#import "ConnectorPreset.h"
#import "CWLSynthesizeSingleton.h"

@implementation ConnectorPresets
CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(ConnectorPresets);

- (id) newConnectorTypes {
    return [NSArray arrayWithObjects:
                      [ConnectorPreset withValue:@0x2 andKey:@"LVDS"],
                      [ConnectorPreset withValue:@0x4 andKey:@"DVI DL"],
                      [ConnectorPreset withValue:@0x200 andKey:@"DVI SL"],
                      [ConnectorPreset withValue:@0x10 andKey:@"VGA"],
                      [ConnectorPreset withValue:@0x80 andKey:@"SV"],
                      [ConnectorPreset withValue:@0x400 andKey:@"DP"],
                      [ConnectorPreset withValue:@0x800 andKey:@"HDMI"],
                      nil
                      ];
}

- (id) newControlFlags {
    return [NSArray arrayWithObjects:
            @"Testvalue",@"Test",
            nil];
}

- (id) newEncodersDigital {
    return [NSArray arrayWithObjects:
            [ConnectorPreset withValue:@0x0 andKey:@"DIG1"],
            [ConnectorPreset withValue:@0x1 andKey:@"DIG2"],
            [ConnectorPreset withValue:@0x2 andKey:@"DIG3"],
            [ConnectorPreset withValue:@0x3 andKey:@"DIG4"],
            [ConnectorPreset withValue:@0x4 andKey:@"DIG5"],
            [ConnectorPreset withValue:@0x5 andKey:@"DIG6"],
            [ConnectorPreset withValue:@0x10 andKey:@"DAC1"],
            [ConnectorPreset withValue:@0x20 andKey:@"DAC2"],
            
            nil];
}

- (id) newEncodersAnalog {
    return [NSArray arrayWithObjects:
            [ConnectorPreset withValue:@0x1 andKey:@"DAC"],
            nil];
}

- (id) newFeatures {
    return [NSArray arrayWithObjects:
            [ConnectorPreset withValue:@0x09 andKey:@"LVDS"],
            [ConnectorPreset withValue:@0x04 andKey:@"S-VIDEO"],
            
            
            /*[ConnectorPreset withValue:@0x00 andKey:@"DISPLAYPORT"],
             [ConnectorPreset withValue:@0x00 andKey:@"HDMI"],
            [ConnectorPreset withValue:@0x00 andKey:@"VGA"],
            [ConnectorPreset withValue:@0x00 andKey:@"DVI"],*/
            
             [ConnectorPreset withValue:@0x00 andKey:@"DP/H/V/D"],
            nil];
    
}

- (id) newTransmitters {
    return [NSArray arrayWithObjects:
            [ConnectorPreset withValue:@0x10 andKey:@"UNIPHY_A"],
            [ConnectorPreset withValue:@0x20 andKey:@"UNIPHY_B"],
            [ConnectorPreset withValue:@0x00 andKey:@"UNIPHY_AB"],
            [ConnectorPreset withValue:@0x11 andKey:@"UNIPHY_C"],
            [ConnectorPreset withValue:@0x21 andKey:@"UNIPHY_D"],
            [ConnectorPreset withValue:@0x01 andKey:@"UNIPHY_CD"],
            [ConnectorPreset withValue:@0x12 andKey:@"UNIPHY_E"],
            [ConnectorPreset withValue:@0x22 andKey:@"UNIPHY_F"],
            [ConnectorPreset withValue:@0x02 andKey:@"UNIPHY_EF"],
            nil];
}


- (id)init {
    if (self = [super init]) {
        _connectorTypes = [self newConnectorTypes];
        _controlFlags = [self newControlFlags];
        _encodersAnalog = [self newEncodersAnalog];
        _encodersDigital = [self newEncodersDigital];
        _features = [self newFeatures];
        _transmitters = [self newTransmitters];
        
    }
    
    return self;
}

@end
