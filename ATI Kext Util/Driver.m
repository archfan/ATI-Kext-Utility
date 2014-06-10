
#import "Driver.h"
#import "Personality.h"
#import "Connector2.h"

#include <stdio.h>

@implementation Driver

NSString* const PREFIX_SCRIPT = @"Script version";
NSString* const PREFIX_PERSONALITY = @"Personality:";
NSString* const PREFIX_OFFSET = @"Disk offset in decimal";
NSString* const PREFIX_CONNECTOR_COUNT = @"ConnectorInfo count in decimal:";

- (NSString*)toolOutput: (NSString*)toolPath forKext: (Kext*)kext
{
    NSTask * task = [[NSTask alloc] init];
	NSPipe * newPipe = [NSPipe pipe];
	NSFileHandle * readHandle = [newPipe fileHandleForReading];
	NSData * inData;
	NSString * outString;
	[task setCurrentDirectoryPath:NSHomeDirectory()];
	[task setLaunchPath:toolPath];
	NSArray *args = [NSArray arrayWithObjects:kext.path, nil];
	[task setArguments:args];
	[task setStandardOutput:newPipe];
	[task setStandardError:newPipe];
	[task launch];
	inData = [readHandle readDataToEndOfFile];
    outString = [[NSString alloc] initWithData:inData encoding:NSASCIIStringEncoding];
	
    if ([outString length] <= 0)
        return nil;
    
    return outString;

}


- initWithKext: (Kext*)kext andAtiPersonalityTool: (NSString*)toolPath
{
    self = [self init];
    
    if(!self)
        return self;
    
    //init code
    NSString* rawOutput = [self toolOutput:toolPath
                          forKext:kext];
    
    NSArray* lines = [rawOutput componentsSeparatedByString:@"\n"];
    
    [self parseLines:lines];
    [self readConnectorsFromExecutable:[kext executeable] error:nil];
    
    return self;
}

- (void)readConnectorsFromExecutable: (NSString*)executable error:(NSError**)error
{
//    char* filename = [executable dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    const char* filename = [executable cStringUsingEncoding:NSASCIIStringEncoding];
    FILE* fp = fopen(filename, "r");
    
    if(!fp) {
//        *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
        printf("%s", filename);
        perror("The following error occured");
        return;
    }
    
    for(Personality* personality in _personalities) {
        //seek to first connector
        fseek(fp, [personality offset], SEEK_SET);
        
        //byte count
        NSInteger length = [Connector2 dataLength] * [personality expectedConnectorCount];
        
        //read connectors
        void* dataPtr = malloc(length);
        fread(dataPtr, length, 1, fp);
        
        NSData* data = [[NSData alloc] initWithBytes:dataPtr length:length];
        
        //set connectors
        [personality setConnectors:[Connector2
                                    connectorsWithData:data
                                    count:[personality expectedConnectorCount]]];
        
        free(dataPtr);
    }
    
    fclose(fp);
}

- (void)parseLines: (NSArray*)lines
{
    /*
     Script version 0.15
     Kext /System/Library/Extensions/AMD4600Controller.kext/Contents/MacOS/AMD4600Controller
     Personality: Flicker
     ConnectorInfo count in decimal: 3
     Disk offset in decimal 658144
     0000000    00  04  00  00  00  04  00  00  00  01  00  00  02  01  03  05
     0000010    00  04  00  00  00  04  00  00  00  01  00  00  01  00  02  02
     0000020    00  02  00  00  14  02  00  00  00  01  00  00  00  10  01  04
     0000030
     Personality: Gliff
     ConnectorInfo count in decimal: 3
     Disk offset in decimal 658192
     0000000    02  00  00  00  40  00  00  00  09  01  00  00  02  01  00  03
     0000010    02  00  00  00  00  01  00  00  09  01  00  00  20  01  02  02
     0000020    00  04  00  00  04  06  00  00  00  01  00  00  10  00  01  01
     0000030
     Personality: Shrike
     ConnectorInfo count in decimal: 3
     Disk offset in decimal 658240
     0000000    02  00  00  00  40  00  00  00  09  01  00  00  02  01  00  03
     0000010    02  00  00  00  00  01  00  00  09  01  00  00  20  01  02  02
     0000020    00  04  00  00  04  03  00  00  00  01  00  00  10  00  01  01
     0000030
     */
    NSMutableDictionary* personalityDictionary = [[NSMutableDictionary alloc] init];
    Personality* activePersonality = nil;
    
    for(NSString* line in lines) {
        //eg. Script version 0.15
        if(_toolVersion == nil && [line hasPrefix:PREFIX_SCRIPT] && activePersonality == nil) {
            //we're outside of an personality
            //handle version line
            
            //cut prefix
            NSString* versionRaw = [line substringFromIndex:[PREFIX_SCRIPT length]];
            
            //trim & save
            _toolVersion = [versionRaw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        //eg. Personality: Flicker
        if([line hasPrefix:PREFIX_PERSONALITY]) {
            //cut prefix
            NSString* personalityRaw = [line substringFromIndex:[PREFIX_PERSONALITY length]];
            //trim
            personalityRaw = [personalityRaw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //set personality active
            activePersonality = [[Personality alloc] initWithName:personalityRaw];
            
            //add to dictionary
            [personalityDictionary setValue:activePersonality forKey:activePersonality.name];
        }
        
        //eg. ConnectorInfo count in decimal: 3
        if([line hasPrefix:PREFIX_CONNECTOR_COUNT] && activePersonality != nil) {
            //cut prefix
            NSString* countRaw = [line substringFromIndex:[PREFIX_CONNECTOR_COUNT length]];
            //trim
            countRaw = [countRaw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //set connector count
            [activePersonality setExpectedConnectorCount:[countRaw integerValue]];
        }
        
        //eg. Disk offset in decimal 658240
        if([line hasPrefix:PREFIX_OFFSET] && activePersonality != nil) {
            //cut prefix
            NSString* offsetRaw = [line substringFromIndex:[PREFIX_OFFSET length]];
            //trim
            offsetRaw = [offsetRaw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            //set offset
            [activePersonality setOffset:[offsetRaw integerValue]];
        }
    }
    
    //apply personalities
    _personalities = [personalityDictionary allValues];
}


- (BOOL)patchExecutable: (NSString*)path error:(NSError**)error
{
    const char* filename = [path cStringUsingEncoding:NSASCIIStringEncoding];
    FILE* fp = fopen(filename, "r+");
    
    if(!fp) {
        //        *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:<#(NSInteger)#> userInfo:<#(NSDictionary *)#>]
        printf("%s", filename);
        perror("The following error occured");
        return NO;
    }
    
    
    for(Personality* personality in _personalities) {
        //seek to first connector
        fseek(fp, [personality offset], SEEK_SET);
        
        NSInteger connectorLength = [Connector2 dataLength];

        for(Connector2* connector in [personality connectors]) {
            const void* data = [connector.data bytes];
            
            for(int i = 0; i < connectorLength; i++) {
                if(i > 0) printf(":");
                printf("%02X", ((char*)data)[i]);
            }
            
            NSLog(@"%ld", (long)[personality offset]);
            fwrite(data, connectorLength, 1, fp);
        }
    }
    
    fclose(fp);
    
    return YES;
}

@end
