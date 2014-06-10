

#import "Kext.h"
#import "ATError.h"

//http://www.techotopia.com/index.php/Working_with_Files_in_Objective-C#Checking_if_a_File_is_Readable.2FWritable.2FExecutable.2FDeletable
//http://macdevelopertips.com/objective-c/objective-c-initializers.html
@implementation Kext

- (id)initWithURL:(NSURL *)url error:(NSError *__autoreleasing *)error
{
    self = [self initWithPath:[url path] error:error];
    
    return self;
}

- (NSString*)programOutput:(NSString*)path arguments: (NSArray*)arguments
{
    NSTask * task = [[NSTask alloc] init];
	NSPipe * newPipe = [NSPipe pipe];
	NSFileHandle * readHandle = [newPipe fileHandleForReading];
	NSData * inData;
	NSString * outString;
	[task setCurrentDirectoryPath:NSHomeDirectory()];
	[task setLaunchPath:path];
	[task setArguments:arguments];
	[task setStandardOutput:newPipe];
	[task setStandardError:newPipe];
	[task launch];
	inData = [readHandle readDataToEndOfFile];
	outString = [[NSString alloc] initWithData:inData encoding:NSASCIIStringEncoding];

    return outString;
}

- (NSString*)codesignCheckForPath:(NSString*)path
{
    NSString* outString = [self programOutput:@"/usr/bin/codesign" arguments:@[@"-v", path]];
    
    if ([outString length] <= 0)
        return nil;
    
    return outString;
}


- (id)initWithPath: (NSString*)path error:(NSError**)error
{
    self = [super init];
    
    if(self) {
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString* infoPath;
        NSString* execDir;
        NSString* execPath;
        BOOL loaded;
        NSDictionary* info;
        
        //Kext "File" readable?
        if ([manager isReadableFileAtPath:path] == NO)
        {
            if(error != NULL)
                *error = [NSError
                          errorWithDomain:ATErrorDomain
                          code:ATKextPathUnreadable
                          userInfo:nil];
            
            return nil;
        }
        
        infoPath = [path stringByAppendingPathComponent:@KEXT_INFO_PATH];
        
        //Info.plist readable?
        if ([manager isReadableFileAtPath:infoPath] == NO)
        {
            if(error != NULL)
                *error = [NSError
                          errorWithDomain:ATErrorDomain
                          code:ATKextInfoPlistUnreadable
                          userInfo:nil];
            
            
            return nil;
        }
        
        info = [[NSMutableDictionary alloc] initWithContentsOfFile:infoPath];
        
        execDir = [path stringByAppendingPathComponent:@KEXT_EXEC_DIR]; //append executable name
        execPath = [execDir stringByAppendingPathComponent:info[@"CFBundleExecutable"]];
        
        //Bla.kext/Contents/MacOS/xxxxx readable?
        if ([manager isReadableFileAtPath:execPath] == NO)
        {
            if(error != NULL)
                *error = [NSError
                          errorWithDomain:ATErrorDomain
                          code:ATKextExecutableUnreadable
                          userInfo:nil];
            
            
            return nil;
        }
        
        //check if loaded
        NSString* kextstat = [self
                             programOutput:@"/usr/sbin/kextstat"
                             arguments: @[@"-l", @"-b", [info valueForKey:@"CFBundleIdentifier"]]
                             ];
        loaded = [kextstat rangeOfString:[info valueForKey:@"CFBundleVersion"]].location != NSNotFound;
//                               NSString* outString =
        
        //everything went ok, set fields
        _path = path;
        _info = info;
        _executeable = execPath;
        _loaded = loaded;
        
        [self setCodeSignInfo:[self codesignCheckForPath:path]];
    }
    
    return self;
}

- (void)setCodeSignInfo:(NSString *)codeSignInfo
{
    _codeSigningOkay = codeSignInfo == nil;
    _codeSignInfo = _codeSigningOkay ? @"ok" : codeSignInfo;
}


- (BOOL)writeToURL: (NSURL*)url error:(NSError**)error
{
    NSLog(@"TODO: Write Info.plist back");
    
    return YES;
}
@end
