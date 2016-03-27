//
//  DDRequestQueue.m
//  myAudi
//
//  Created by Dominik Pich on 2/1/16.
//  Copyright © 2016 Sapient GmbH. All rights reserved.
//
#import <SystemConfiguration/SystemConfiguration.h>

#import "DDRequestQueue.h"
#if DDREQUESTQUE_USES_URL_SESSION == 2
#import <AFNetworking/AFNetworking.h>
#endif

@interface DDRequestQueue ()

@property(readwrite) NSString *name;
@property(readwrite) BOOL persistent;
@property(readwrite) NSArray *queuedRequests;
@property(readwrite) BOOL queueRunning;
@property(assign) SCNetworkReachabilityRef currentReachability;
@end

@implementation DDRequestQueue

#define kDefaultName @"defaultQueue"
#define kDefaultIsPersistent YES
#define kDataKey @"Data"

+ (instancetype)defaultQueue {
    static dispatch_once_t onceToken;
    static id _defaultQueue;
    dispatch_once(&onceToken, ^{
        _defaultQueue = [[[self class] alloc] initWithName:kDefaultName persistent:kDefaultIsPersistent];
    });
    return _defaultQueue;
}

- (id)initWithName:(NSString*)name persistent:(BOOL)persistent {
    self = [super init];
    if(self) {
        self.suspended = YES;
        self.name = name;
        self.persistent = persistent;
        self.queuedRequests = [NSMutableArray array];
        
        if(self.persistent) {
            BOOL br = [self load];
            NSAssert(br, @"Failed to load persistent queue");
            
            if(!br) {
                @throw [NSException exceptionWithName:@"Internal" reason:@"Failed to load persistent queue" userInfo:nil];
            }
        }
    }
    return self;
}

- (BOOL)enqueueRequest:(NSURLRequest*)request {
    NSParameterAssert(request);
    
    BOOL oldSuspended = self.suspended;
    self.suspended = YES;

    [(NSMutableArray*)self.queuedRequests addObject:request];
    
    BOOL br = [self.queuedRequests containsObject:request];
    NSAssert(br, @"Failed to enqueue the object");
    
    if(br) {
        if(self.persistent) {
            br = [self save];
            NSAssert(br, @"Failed to persist queue after enqueing request: %@", request);
        }
    }
    
    if(br) {
        self.suspended = oldSuspended;
    }
    
    return br;
}

- (BOOL)cancelRequest:(NSURLRequest*)request {
    NSParameterAssert(request);
    
    BOOL oldSuspended = self.suspended;
    self.suspended = YES;
    
    BOOL br = [self.queuedRequests containsObject:request];
    NSAssert(br, @"request should be enqueued");
    
    if(br) {
        [(NSMutableArray*)self.queuedRequests removeObject:request];
        br = ![self.queuedRequests containsObject:request];
        NSAssert(br, @"request shouldnt be enqueued anymore");
    }
    
    if(br) {
        if(self.persistent) {
            br = [self save];
            NSAssert(br, @"Failed to persist queue after canceling request: %@", request);
        }
    }
    
    self.suspended = oldSuspended;
    
    return br;
}

- (BOOL)cancelAllRequests {
    BOOL oldSuspended = self.suspended;
    self.suspended = YES;

    [(NSMutableArray*)self.queuedRequests removeAllObjects];
    BOOL br = self.queuedRequests.count == 0;
    NSAssert(br, @"no requests shouldnt be enqueued anymore");

    if(br) {
        if(self.persistent) {
            br = [self save];
            NSAssert(br, @"Failed to persist queue after canceling all requests");
        }
    }
    
    self.suspended = oldSuspended;
    
    return br;
}

- (void)setSuspended:(BOOL)suspended {
    _suspended = suspended;
    if(!_suspended && !self.queueRunning)
        [self doNextRequest];
}

#pragma mark - 

-(void)doNextRequest {
    //break if suspended
    if(self.suspended) {
        return;
    }
    
    __weak typeof(self) wself = self;

    //go to main thread
    if(![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself doNextRequest];
        });
    }
    
    //dequeue first
    NSMutableArray *requests = (NSMutableArray*)self.queuedRequests;
    NSURLRequest *request = [requests firstObject];
    if(!request) {
        return;
    }
    [requests removeObjectAtIndex:0];
    
    self.queueRunning = YES;
#if DDREQUESTQUE_USES_URL_SESSION == 1
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [wself didFinishRequest:request
                   withResponse:response
                  includingData:data
                       andError:error];
    }] resume];
#elif DDREQUESTQUE_USES_URL_SESSION == 2
//    NSLog(@"+ start: %@", request.URL);
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
                                         initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [wself didFinishRequest:request
                   withResponse:operation.response
                  includingData:operation.responseData
                       andError:nil];
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [wself didFinishRequest:request
                   withResponse:operation.response
                  includingData:operation.responseData
                       andError:error];
    }];
    [operation start];
    
#else
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               [wself didFinishRequest:request
                                          withResponse:response
                                         includingData:data
                                              andError:connectionError];
                           }];
#endif
}

- (void)didFinishRequest:(NSURLRequest*)request
            withResponse:(NSURLResponse*)response
           includingData:(NSData*)data
                andError:(NSError*)error {
    //go to main thread if needed
    if(![NSThread isMainThread]) {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself didFinishRequest:request withResponse:response includingData:data andError:error];
        });
        return;
    }
    
    //handle network error
    if(error && [self isNetworkRelatedError:error]) {
//        NSLog(@"+ Will Retry when network is up: %@", request.URL);
        
        //prepare to retry the request
        [(NSMutableArray*)self.queuedRequests insertObject:request atIndex:0];
        
        //wait for network coming back
        [self beginObservingReachabilityStatusForHost:request.URL.host];
        
        return;
    }

//    NSLog(@"+ Did finish: %@", request.URL);
    
    self.queueRunning = NO;

    //we are done with this one, save the array
    if(self.persistent) {
        [self save];
        //errors ignored
    }
    
    //tell our subclass and the delegate everything else
    [self dequeuedRequest:request withResponse:response includingData:data andError:error];
    
    //go on
    [self doNextRequest];
}

- (BOOL)isNetworkRelatedError:(NSError*)error {
    if ([[error domain] isEqualToString:NSURLErrorDomain]){
        switch ([error code]){
            case NSURLErrorInternationalRoamingOff:
            case NSURLErrorCallIsActive:
            case NSURLErrorDataNotAllowed:
            case NSURLErrorNotConnectedToInternet:
                return YES;
        }
    }
    return NO;
}

- (void)dequeuedRequest:(NSURLRequest*)request withResponse:(NSURLResponse*)response includingData:(NSData*)data andError:(NSError*)error {
    id<DDRequestQueueDelegate> delegate = self.delegate;
    if([delegate respondsToSelector:@selector(requestQueue:dequeuedRequest:withResponse:includingData:andError:)]) {
        [delegate requestQueue:self dequeuedRequest:request withResponse:response includingData:data andError:error];
    }
}

#pragma mark -

- (BOOL)load {
    NSURL *docURL = [self URLForPersistentQueue];
    BOOL br = YES;
    
    //if it doesnt exist, quit
    //if it does, read it
    if([[NSFileManager defaultManager] fileExistsAtPath:docURL.path]) {
        NSData *codedData = [[NSData alloc] initWithContentsOfURL:docURL];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        NSArray *array = [unarchiver decodeObjectForKey:kDataKey];
        [unarchiver finishDecoding];
        
        NSMutableArray *requests = (NSMutableArray*)self.queuedRequests;
        [requests removeAllObjects];
        if(array.count) {
            [requests addObjectsFromArray:array];
        }
    }

    return br;
}

- (BOOL)save {
    NSArray *array = self.queuedRequests;
    NSURL *docURL = [self URLForPersistentQueue];
    BOOL br = YES;

    //if the array is empty, delete the doc if it exists
    //if the array isnt empty, write it

    if(array.count == 0) {
        if([[NSFileManager defaultManager] fileExistsAtPath:docURL.path]) {
            br = [[NSFileManager defaultManager] removeItemAtURL:docURL error:nil];
        }
    }
    else {
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:array forKey:kDataKey];
        [archiver finishEncoding];
        
        br = [data writeToURL:docURL atomically:YES];
    }
    return br;
}

- (NSURL*)URLForPersistentQueue {
    NSURL *library = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *appDir = [library URLByAppendingPathComponent:@"DDRequestQueue"];
    [[NSFileManager defaultManager] createDirectoryAtURL:appDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filename = [@"QueuedRequests-" stringByAppendingString:self.name];
    
    return [appDir URLByAppendingPathComponent:filename];
}

#pragma mark - 

- (void) beginObservingReachabilityStatusForHost:(NSString *)host {
    NSAssert(self.currentReachability==NULL, @"The current reachability should be NULL");
    
    SCNetworkReachabilityRef reachabilityRef = NULL;
    
    void (^callbackBlock)(SCNetworkReachabilityFlags) = ^(SCNetworkReachabilityFlags flags) {
        BOOL reachable = (flags & kSCNetworkReachabilityFlagsReachable) != 0;
        [self host:host didBecomeReachable:reachable];
    };
    
    SCNetworkReachabilityContext context = {
        .version = 0,
        .info = (void *)CFBridgingRetain(callbackBlock),
        .release = CFRelease
    };
    
    
    if ([host length] > 0){
        reachabilityRef = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, [host UTF8String]);
        if (SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context)){
            if (!SCNetworkReachabilitySetDispatchQueue(reachabilityRef, dispatch_get_main_queue()) ){
                // Remove our callback if we can't use the queue
                SCNetworkReachabilitySetCallback(reachabilityRef, NULL, NULL);
            }
            self.currentReachability = reachabilityRef;
        }
    }
}


static void ReachabilityCallback(SCNetworkReachabilityRef __unused target, SCNetworkConnectionFlags flags, void* info) {
    void (^callbackBlock)(SCNetworkReachabilityFlags) = (__bridge id)info;
    callbackBlock(flags);
}


- (void) host:(NSString *)__unused host didBecomeReachable:(BOOL)reachable {
    if (reachable){
        [self doNextRequest];
        
        SCNetworkReachabilitySetDispatchQueue(self.currentReachability, NULL);
        CFRelease(self.currentReachability);
        self.currentReachability = NULL;
    }
}

@end
