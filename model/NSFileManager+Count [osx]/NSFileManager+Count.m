#import "NSFileManager+Count.h"

@implementation NSFileManager (count)

FSRef convertNSStringToFSRef(NSString * theString) {
    FSRef output;
    const char *filePathAsCString = [theString UTF8String];
    CFURLRef url = CFURLCreateWithBytes(kCFAllocatorDefault, 
                                        (const UInt8 *)filePathAsCString, 
                                        strlen(filePathAsCString),
                                        kCFStringEncodingUTF8,
                                        NULL);
    CFURLGetFSRef(url, &output);
    CFRelease(url);
    return output;
}

- (NSInteger) countOfFilesInDirectory:(NSString *) inPath
{
	FSRef ref = convertNSStringToFSRef(inPath);
	FSCatalogInfo catInfo;
	
	OSErr  err    = FSGetCatalogInfo(&ref, kFSCatInfoValence,
									 &catInfo, NULL, NULL, NULL);
	if (err == noErr)
		return catInfo.valence;
	else
		NSLog(@"get cat info error: %hi", err);
	
	return NSNotFound;
}

@end