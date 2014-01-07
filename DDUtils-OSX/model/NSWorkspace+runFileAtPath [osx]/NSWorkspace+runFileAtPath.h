//
//  NSWorkspace+runFileAtPath.h
//  Proximity
//
//  Created by Dominik Pich on 7/25/12.
//
//

#import <Cocoa/Cocoa.h>

/**
 * category that provides a method to run any file. It can be:
 *  an Applescript (NSApplescript is used)
 *  a shell script or exectuable (NSTask is used)
 *  a file wrapper or app (NSWorkspace is used)
 *  a directory is opened with the finder
 *
 * arguments are passed to the Apple Scripts, Shell scripts, to an app and to unix executable
 */
@interface NSWorkspace (runFileAtPath)

/**
 * runs a file at the specified path.
 * @param path the file to run which can be anything there is :)
 * @param array of arguments passed to the file which should be Strings
 * @param pError in case of error, this is filled with an NSError
 * @return the success of the run: YES or NO
 */
- (BOOL)runFileAtPath:(NSString *)path arguments:(NSArray *)args error:(NSError **)pError;

@end
