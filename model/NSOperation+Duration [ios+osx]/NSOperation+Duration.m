//
//  NSOperation+Duration.m
//  NSOperationTimingTest
//
//  Created by Dominik Pich on 16.03.13.
//  Copyright (c) 2013 Dominik Pich. All rights reserved.
//

#import "NSOperation+Duration.h"
#import <objc/runtime.h>
#import <sys/time.h>

static void * const kDDAssociatedStorageDurationStart = (void*)&kDDAssociatedStorageDurationStart;
static void * const kDDAssociatedStorageDurationEnd = (void*)&kDDAssociatedStorageDurationEnd;

@implementation NSOperation (Duration)

+ (void)load {
    SEL originalSelector = @selector(init);
    SEL overrideSelector = @selector(init_xchg);
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }    

    SEL deallocSel = NSSelectorFromString(@"dealloc");
    originalSelector = deallocSel;
    overrideSelector = @selector(dealloc_xchg);
    originalMethod = class_getInstanceMethod(self, originalSelector);
    overrideMethod = class_getInstanceMethod(self, overrideSelector);
    if (class_addMethod(self, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(self, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

- (void)setDurationStart:(NSNumber *)duration {
    objc_setAssociatedObject(self, kDDAssociatedStorageDurationStart, duration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)durationStart {
    return objc_getAssociatedObject(self, kDDAssociatedStorageDurationStart);
}

- (void)setDurationEnd:(NSNumber *)duration {
    objc_setAssociatedObject(self, kDDAssociatedStorageDurationEnd, duration, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)durationEnd {
    return objc_getAssociatedObject(self, kDDAssociatedStorageDurationEnd);
}

#pragma mark - 

- (id)init_xchg {
    self = [self init_xchg];
    if(self)
        [self addObserver:self forKeyPath:@"isExecuting" options:0 context:0];
    return self;
}

- (void)dealloc_xchg {
    [self removeObserver:self forKeyPath:@"isExecuting" context:0];
    [self dealloc_xchg];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    struct timeval watch;
    gettimeofday(&watch, NULL);

    if(self.isExecuting) {
        //set start and reset end
        double fstart = (watch.tv_sec * 1000000.0 + watch.tv_usec) / 1000000.0;
        self.durationStart = [NSNumber numberWithDouble:fstart];
        self.durationEnd = nil;
    }
    else {
        //set end
        double fend = (watch.tv_sec * 1000000.0 + watch.tv_usec) / 1000000.0;
        self.durationEnd = [NSNumber numberWithDouble:fend];
    }
}
#pragma mark -

- (NSTimeInterval)duration {
    double fstart = self.durationStart.doubleValue;
    double fend = self.durationEnd.doubleValue;
    if(fstart < 0 || fend < 0 || fstart > fend) {
        printf("*** TIMINGS BROKEN***");
    }
    return fend - fstart;
}

@end
