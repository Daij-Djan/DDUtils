//
//  DDChecksum.h
//  Created by Dominik Pich on 26.03.11.
//
#import <Foundation/Foundation.h>

typedef enum _DDChecksumType {
    DDChecksumTypeMD5,
    DDChecksumTypeSha512
    /*...any CC algo can be used*/
} DDChecksumType;

@interface DDChecksum : NSObject

+ (NSString *)checksum:(DDChecksumType)type forData:(NSData*)data;

@end
