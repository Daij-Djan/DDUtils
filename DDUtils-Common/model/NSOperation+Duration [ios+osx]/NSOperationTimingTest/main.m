//
//  main.m
//  NSOperationTimingTest
//
//  Created by Dominik Pich on 16.03.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOperation+Duration.h"
#import "AFHTTPRequestOperation.h"

@interface NSTestOperation : NSOperation
@end
@implementation NSTestOperation {
    NSNumber *_number;
}

- (NSNumber *)number {
    return _number;
}

- (int)sleepTime {
    return _number.intValue%2 + 1;
}

- (id)initWithNumber:(NSNumber *)number {
    self = [super init];
    if (self)
        _number = number;
    return self;
}

- (void)main {
    sleep(self.sleepTime);
}

@end

int main(int argc, const char *argv[])
{
    @autoreleasepool {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        //our simple test operations
        for(int i = 0; i < 3; i++) {
            NSTestOperation *operation = [[NSTestOperation alloc] initWithNumber:@(i)];
            __block NSTestOperation *o = operation;
            operation.completionBlock = ^{
                NSLog(@"operation with %@ (sleeps %d) took: ~ %f seconds", o.number, o.sleepTime, o.duration);
                if (queue.operationCount==0)
                    exit(1);
            };
            [queue addOperation:operation];
        }
        
        //AFNetwork test
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.de"]]];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"download of %@ took: ~ %f seconds", operation.request.URL, operation.duration);
            if (queue.operationCount==0)
                exit(1);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"download of %@ failed after: ~ %f seconds", operation.request.URL, operation.duration);
            if (queue.operationCount==0)
                exit(1);
        }];
        [queue addOperation:operation];

        [[NSRunLoop currentRunLoop] run];
    }
    
    return 0;
}

