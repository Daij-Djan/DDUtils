//
//  DDChecksum.m
//  Created by Dominik Pich on 26.03.11.
//
#import "DDChecksum.h"
#import <CommonCrypto/CommonDigest.h>

@implementation DDChecksum

#pragma mark sha

+ (NSString *)hexForDigest:(unsigned char*)ret ofLength:(int)l
{
	if(ret && l>0) 
	{
        NSMutableString* output = [NSMutableString stringWithCapacity:l * 2];
        
        for(int i = 0; i < l; i++)
            [output appendFormat:@"%02x", ret[i]];
        
        return output;
	}	
	return nil;
}

+ (NSString *)checksum:(DDChecksumType)type forData:(NSData *)data
{
    unsigned char *ret = nil;
    int l = 0;
    
    switch (type) {
        case DDChecksumTypeSha512: 
        {
            l = CC_SHA512_DIGEST_LENGTH;
            unsigned char digest[CC_SHA512_DIGEST_LENGTH];
            ret = CC_SHA512([data bytes], (CC_LONG)[data length], digest);
            break;
        }
            
        case DDChecksumTypeMD5:
        {
            l = CC_MD5_DIGEST_LENGTH;
            unsigned char digest[CC_MD5_DIGEST_LENGTH];
            ret = CC_MD5([data bytes], (CC_LONG)[data length], digest);        
        }
            
        default:
            break;
    }
    
	return [self hexForDigest:ret ofLength:l];
}

@end