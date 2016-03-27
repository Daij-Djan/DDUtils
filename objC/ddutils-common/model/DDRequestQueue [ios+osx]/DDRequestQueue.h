//
//  DDRequestQueue.h
//  myAudi
//
//  Created by Dominik Pich on 2/1/16.
//  Copyright © 2016 Sapient GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDRequestQueueDelegate;

//when created/loaded from disk, the queue is suspended by default
//should be used on main thread 
@interface DDRequestQueue : NSObject

+ (instancetype)defaultQueue; //persisted, internet reachability
- (id)initWithName:(NSString*)name persistent:(BOOL)persistent; //internet reachability

- (BOOL)enqueueRequest:(NSURLRequest*)request; //queue will suspend if the enqueue fails
- (BOOL)cancelRequest:(NSURLRequest*)request;
- (BOOL)cancelAllRequests;
@property(nonatomic, getter=isSuspended) BOOL suspended;
@property id<DDRequestQueueDelegate> delegate;

@property(readonly) NSString *name;
@property(readonly,getter=isPersistent) BOOL persistent;
@property(readonly) NSArray *queuedRequests;
@property(readonly) BOOL queueRunning;
@end

@interface DDRequestQueue (ForSubclassing)

//this will inform the delegate but can be overriden for additional behavior
//called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
- (void)dequeuedRequest:(NSURLRequest*)request
           withResponse:(NSURLResponse*)response
          includingData:(NSData*)data
               andError:(NSError*)error __attribute__((objc_requires_super));

@end

@protocol DDRequestQueueDelegate <NSObject>

//called after done with a request for good or for bad -- this EXCLUDES network errors AND cancellations
- (void)requestQueue:(DDRequestQueue*)requestQueue
     dequeuedRequest:(NSURLRequest*)request
        withResponse:(NSURLResponse*)response
       includingData:(NSData*)data
            andError:(NSError*)error;

@end

#ifndef DDREQUESTQUE_USES_URL_SESSION
#define DDREQUESTQUE_USES_URL_SESSION 1 //uses NSURLSession by default. if you wanna change that, define 0 and it'll fall back to NSURLConnection OR define 2 for AFNetworking 2.x
#endif