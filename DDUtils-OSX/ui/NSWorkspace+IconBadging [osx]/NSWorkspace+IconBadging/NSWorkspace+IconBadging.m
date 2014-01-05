//
//  NSWorkspace+IconBadging.m
//
//  Created by Dominik Pich on 20.8.12.
//  Copyright (c) 2012 Dominik Pich. All rights reserved.
//  partly based on an initial implementation for doo from 2011
//

#import "NSWorkspace+IconBadging.h"
#import <Carbon/Carbon.h>
#import <sys/stat.h>

//partly deprecated in 10.8.
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

BOOL AddBadgeToItem(NSString* path,NSData* tag); //to shut compiler ;)
BOOL AddBadgeToItem(NSString* path,NSData* tag)
{
    static int32_t _iconIdCounter = 100;//this is needed because the finder caches the badge based on the resource ID.
    
    FSCatalogInfo info;
    FSRef par; //path to file for which to open the fork
	FSRef ref; //ref to fork file
    Boolean dir = false;
	
    OSStatus res = FSPathMakeRef((const uint8*)[path fileSystemRepresentation],&par,&dir);
    if(res!=noErr) {
        NSLog(@"Failed to resolve %@", path);
        return NO;
    }
    
    HFSUniStr255 fork = {0,{0}};
    ResFileRefNum refnum = kResFileNotOpened;
    FSGetResourceForkName(&fork);
    
    if (dir)
    {
        //make the icon file and pass it on
        //ref = ico;
        
        NSString *name = @"Icon\r";
        memset(&info,0,sizeof(info));
        ((FileInfo*)(&info.finderInfo))->finderFlags = kIsInvisible;
        
        OSErr error = FSCreateResourceFile(&par,[name lengthOfBytesUsingEncoding:NSUTF16LittleEndianStringEncoding],(UniChar*)[name cStringUsingEncoding:NSUTF16LittleEndianStringEncoding],kFSCatInfoFinderXInfo,&info,fork.length, fork.unicode,&ref,NULL);
        
        if( error == dupFNErr )
        {
            // file already exists; prepare to try to open it
            const char *iconFileSystemPath = [[path stringByAppendingPathComponent:@"Icon\r"] fileSystemRepresentation];
            
            OSStatus status = FSPathMakeRef((const UInt8 *)iconFileSystemPath, &ref, NULL);
            if (status != noErr)
            {
                fprintf(stderr, "error: FSPathMakeRef() returned %d for file \"%s\"\n", (int)status, iconFileSystemPath);
                
            }
        }
        else if ( error != noErr) {
            return NO;
        }
        
        //get flags of ico to make it invisible
        res = FSGetCatalogInfo(&ref,kFSCatInfoFinderXInfo,&info,NULL,NULL,NULL);
        if (res!=noErr) {
            NSLog(@"Cant get flags of icon file");
            return NO;
        }
        
        //set flags
        ((FileInfo*)(&info.extFinderInfo))->finderFlags = kIsInvisible;
        res = FSSetCatalogInfo(&ref,kFSCatInfoFinderInfo,&info);
        if (res!=noErr) {
            NSLog(@"Cant make icon file invisible");
            return NO;
        }
    }
    else
    {
        //get the fork
        OSErr oserr = FSCreateResourceFork(&par,fork.length,fork.unicode,0);
        if (oserr!=noErr)
        {
            // We may not have permissions to set resources in debug runs
            if ((oserr == noErr) || (oserr == wrPermErr) || (oserr == permErr)) {
                NSLog(@"We may not have permissions to set resources in debug runs");
                return NO;
            }
            
            //reset the fork
            if (FSOpenResourceFile(&par,fork.length,fork.unicode,fsRdWrPerm,&refnum)!=noErr) {
                NSLog(@"FSOpenResourceFile failed");
                return NO;
            }
            
            //update the flags
            if (refnum!=kResFileNotOpened) {
                
                UpdateResFile(refnum);
                CloseResFile(refnum);
                
                res = FSGetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info,NULL,NULL,NULL);
                if (res!=noErr) {
                    NSLog(@"FSGetCatalogInfo");
                    return NO;
                }
                ((ExtendedFileInfo*)(&info.extFinderInfo))->extendedFinderFlags = kExtendedFlagsAreInvalid;
                res = FSSetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info);
                if(res != noErr) {
                    NSLog(@"FSSetCatalogInfo failed");
                    return NO;
                }
            }
        }
        
        //copy the filehandle
        memcpy(&ref, &par, sizeof(FSRef));
    }
    
    //open for and save icon
    OSErr errorr = FSOpenResourceFile(&ref,fork.length,fork.unicode,fsRdWrPerm,&refnum);
    if (errorr!=noErr) {
        NSLog(@"FSOpenResourceFile failed");
        return NO;
    }
    
    if (refnum==kResFileNotOpened) {
        NSLog(@"FSOpenResourceFile wasnt opened");
        return NO;
    }
    
//    //debug
//    Handle ha = Get1Resource(kIconFamilyType,_iconIdCounter);
//    NSLog(@"%ld<>%ld", GetHandleSize(ha), tag.length);

    //write icon
    CustomBadgeResource* cbr;
    long len = [tag length];
    Handle h = NewHandle(len);
    if (!h) {
        NSLog(@"Failed to create new handle for setting path");
        return NO;
    }
    memcpy(*h,[tag bytes],len);
    AddResource(h,kIconFamilyType,_iconIdCounter,"\p");
    WriteResource(h);
    ReleaseResource(h);
    
    h = NewHandle(sizeof(CustomBadgeResource));
    if (!h) {
        NSLog(@"Failed to create new handle for setting icon structure");
        return NO;
    }
    cbr = (CustomBadgeResource*)*h;
    memset(cbr,0,sizeof(CustomBadgeResource));
    cbr->version = kCustomBadgeResourceVersion;
    cbr->customBadgeResourceID = _iconIdCounter;
    AddResource(h,kCustomBadgeResourceType,kCustomBadgeResourceID,"\p");
    WriteResource(h);
    ReleaseResource(h);
    
    //prepare icon counter
    if(_iconIdCounter <= 0)
        _iconIdCounter = 100;
    _iconIdCounter++;
    
//    //debug
//    ha = Get1Resource(kIconFamilyType,_iconCounter);
//    NSLog(@"%ld<>%ld", GetHandleSize(ha), tag.length);

    //close it
    UpdateResFile(refnum);
    CloseResFile(refnum);

    //set finder flags
    res = FSGetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info,NULL,NULL,NULL);
    if (res!=noErr) {
        NSLog(@"FSGetCatalogInfo");
        return NO;
    }
    ((ExtendedFileInfo*)(&info.extFinderInfo))->extendedFinderFlags = kExtendedFlagHasCustomBadge;
    res = FSSetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info);
    if(res!=noErr) {
        NSLog(@"FSSetCatalogInfo failed");
        return NO;
    }

    return YES;
}

BOOL RemoveBadge(NSString *path);
BOOL RemoveBadge(NSString *path)
{
    FSCatalogInfo info;
    FSRef par; //path to file for which to open the fork
	FSRef ref; //ref to fork file
    Boolean dir = false;
	
    OSStatus res = FSPathMakeRef((const uint8*)[path fileSystemRepresentation],&par,&dir);
    if (res!=noErr) {
        NSLog(@"Failed to resolve %@", path);
        return NO;
    }

    //find FSGetResourceForkName
    HFSUniStr255 fork = {0,{0}};
    ResFileRefNum refnum = kResFileNotOpened;
    FSGetResourceForkName(&fork);
	if(res!=noErr) {
        NSLog(@"FSGetResourceForkName failed");
        return NO;
    }
    
    if (dir)
    {
        // file already exists; prepare to try to open it
        const char *iconFileSystemPath = [[path stringByAppendingPathComponent:@"Icon\r"] fileSystemRepresentation];
        OSStatus status = FSPathMakeRef((const UInt8 *)iconFileSystemPath, &ref, NULL);
        if (status != noErr)
        {
            //return because file doesnt exist
            return NO;
        }
    }
    else
    {
        //get the fork
        OSErr oserr = FSCreateResourceFork(&par,fork.length,fork.unicode,0);
        if (oserr!=noErr)
        {
            // We may not have permissions to set resources in debug runs
            if ((oserr == noErr) || (oserr == wrPermErr) || (oserr == permErr)) {
                NSLog(@"We may not have permissions to set resources in debug runs");
                return NO;
            }
            
            //open and set flags to invalid
            res = FSOpenResourceFile(&par,fork.length,fork.unicode,fsRdWrPerm,&refnum);
            if (res!=noErr) {
                NSLog(@"FSOpenResourceFile failed: %d", res);
                return NO;
            }
            if (refnum==kResFileNotOpened) {
                NSLog(@"FSOpenResourceFile failed to open the resource file");
                return NO;
            }
            
            UpdateResFile(refnum);
            CloseResFile(refnum);
            
            if (FSGetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info,NULL,NULL,NULL)==noErr) {
                ((ExtendedFileInfo*)(&info.extFinderInfo))->extendedFinderFlags = kExtendedFlagsAreInvalid;
                res = FSSetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info);
                if(res!=noErr) {
                    NSLog(@"FSSetCatalogInfo failed: %d", res);
                    return NO;
                }
            }
            
        }
        memcpy(&ref, &par, sizeof(FSRef));
    }
		
    //open for and save icon
    OSErr errorr = FSOpenResourceFile(&ref,fork.length,fork.unicode,fsRdWrPerm,&refnum);
    if (errorr!=noErr) {
        NSLog(@"FSOpenResourceFile failed");
        return NO;
    }
    
    if (refnum==kResFileNotOpened) {
        NSLog(@"Failed to open resource file");
        return NO;
    }
    
    // remove existing badge
    BOOL hasIcon = YES;
    BOOL first = YES;
    while (hasIcon) {
        CustomBadgeResource **cbr = (CustomBadgeResource**) Get1Resource(kCustomBadgeResourceType,kCustomBadgeResourceID);
        if (!cbr) {
//            if(first) {
//                NSLog(@"Failed to find CustomBadgeResource");
//                return NO;
//            }
//            else
                break;
        }
        else if(!first) {
            NSLog(@"Retry to delete icon");
        }
        
        first = NO;
        
        if (GetHandleSize((Handle)cbr) < sizeof(CustomBadgeResource)) {
            NSLog(@"Handle is too small");
            return NO;
        }
        
        if ((**cbr).version != kCustomBadgeResourceVersion)
        {
            NSLog(@"CustomBadgeResource's version is wrong: %d!=%d", (**cbr).version, kCustomBadgeResourceVersion);
            return NO;
        }
        
        //get handle to path via ID stored in struct
        Handle h = Get1Resource(kIconFamilyType,(**cbr).customBadgeResourceID);
        if (!h)
        {
            NSLog(@"Cant get handle for CustomBadgeResource's ID=%d", (**cbr).customBadgeResourceID);
            return NO;
        }
        //rm h
        RemoveResource(h);
        WriteResource(h);
        ReleaseResource(h);
        
        //rm cbr
        RemoveResource((Handle)cbr);
        ReleaseResource((Handle)cbr);

        //close
        UpdateResFile(refnum);
        CloseResFile(refnum);
    }
    
    //set flags to invalid
    res = FSGetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info,NULL,NULL,NULL);
    if (res!=noErr) {
        NSLog(@"FSGetCatalogInfo failed");
        return NO;
    }
    ((ExtendedFileInfo*)(&info.extFinderInfo))->extendedFinderFlags = kExtendedFlagsAreInvalid;
    res = FSSetCatalogInfo(&par,kFSCatInfoFinderXInfo,&info);
    if (res!=noErr) {
        NSLog(@"FSSetCatalogInfo failed");
        return NO;
    }
    
    //rm the ICON file of directory
    if (dir)
    {
        // file already exists; prepare to try to open it
        const char *iconFileSystemPath = [[path stringByAppendingPathComponent:@"Icon\r"] fileSystemRepresentation];
        OSStatus status = FSPathMakeRef((const UInt8 *)iconFileSystemPath, &ref, NULL);
        if (status != noErr)
        {
            //fprintf(stderr, "error: FSPathMakeRef() returned %d for file \"%s\"\n", (int)status, iconFileSystemPath);
            return NO;
            
        }
        FSDeleteObject(&ref);
    }
    
    return YES;
}

@implementation NSWorkspace (IconBadging)

- (void)setIconBadge:(NSString*)badgePath atFilePath:(NSString*)filePath {
    NSParameterAssert(filePath);

    BOOL br = RemoveBadge(filePath);
    if(!badgePath) {
        if(br) {
            [[NSWorkspace sharedWorkspace] noteFileSystemChanged:filePath];
        }
        return;
    }
    
    NSData *data;
//    static NSMutableDictionary *_cachedData;
//    if(_cachedData) {
//		data = [_cachedData objectForKey:badgePath];
//	} else {
//		_cachedData = [[NSMutableDictionary alloc] init];
//	}
	
//	if(!data) {
//		NSLog(@"Cache miss: Load badge from disk");
		data = [NSData dataWithContentsOfFile:badgePath];
//		[_cachedData setObject:data forKey:badgePath];
//	}
	
    if(data) {
        BOOL br = AddBadgeToItem(filePath, data);
        if(br) {
            [[NSWorkspace sharedWorkspace] noteFileSystemChanged:filePath];
        }
        else {
            NSLog(@"Error: couldnt set icon badge for file at %@", filePath);
        }
    }
}

- (void)removeIconBadgeAtFilePath:(NSString*)filePath {
    NSParameterAssert(filePath);
    
	BOOL br = RemoveBadge(filePath);
	if(br) {
		[[NSWorkspace sharedWorkspace] noteFileSystemChanged:filePath];
	}
	else {
		NSLog(@"Error: couldnt remove icon badge for file at %@", filePath);
	}	

}

@end