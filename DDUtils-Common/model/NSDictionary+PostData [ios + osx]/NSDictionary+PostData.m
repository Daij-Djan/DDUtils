//
//  NSDictionary+multipartPostData.m
//  Project
//
//  Created by Dominik Pich on 31.08.09.
//  Copyright 2009 Medicus 42 GmbH. All rights reserved.
//

#import "NSDictionary+PostData.h"

#define POST_BOUNDARY @"-=-=-=123142123123POST%^%(&=-=-=-";

@implementation NSDictionary (PostData)

/*- (NSData*)postData {
    NSMutableString *post = [[NSMutableString alloc] init];

	for(NSString *key in [self allKeys]) {
		[post appendFormat:@"%@=%@&", key, [self objectForKey:key]];
	}

	CFStringTrim((CFMutableStringRef)post, (CFStringRef)@"&");

	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[post release];
    return postData;
}
*/

- (NSData*)postData {
	NSString *stringBoundary = POST_BOUNDARY;
	NSMutableData *postBody = [NSMutableData data];

	for(NSString *key in [self allKeys]) {
		if([key isKindOfClass:[NSString class]]) {
			id value = [self objectForKey:key];
			if([value isKindOfClass:[NSString class]]) {
				if([postBody length])
					[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
			}
			else if([value isKindOfClass:[NSData class]]) {
				NSString *filename = @"file.bin";

				if([postBody length])
					[postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key,filename] dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:[@"Content-Transfer-Encoding: binary/video\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
				[postBody appendData:value];

				[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		else {
			NSLog(@"EXCEPTION: Cant handle anything but NSString or NSData");
		}
	}

	return postBody;
}

@end