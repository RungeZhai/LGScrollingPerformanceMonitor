//
//  UIScrollView+LGPerformanceMonitor.m
//  LGScrollingPerformanceMonitor
//
//  Created by liuge on 8/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+LGPerformanceMonitor.h"


@implementation UIScrollView (LGPerformanceMonitor)

@dynamic averageFPS;
@dynamic totalAverageFPS;
@dynamic displayLink;
@dynamic lastLogTime;
@dynamic frameCountInLastInterval;
@dynamic totalFrameCount;
@dynamic totalScrollingTime;


+ (void)load {
    [self swizzleMethod:@selector(didMoveToWindow) withMethod:@selector(swizzled_didMoveToWindow)];
    [self swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(swizzled_dealloc)];
}

+ (void)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector {
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
     
- (void)swizzled_didMoveToWindow {
    [self swizzled_didMoveToWindow];
    
    if ([self window]) {
        [self scrollingStatusDidChange];
    } else {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)swizzled_dealloc {
    [self swizzled_dealloc];
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)scrollingStatusDidChange {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollingStatusDidChange) object:nil];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    NSString *currentRunLoopMode = [runLoop currentMode];
    
    BOOL isScrolling = [currentRunLoopMode isEqualToString:UITrackingRunLoopMode];
    
    if (isScrolling) {
        if (!self.displayLink) {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(screenDidUpdateWhileScrolling)];
            [self.displayLink addToRunLoop:runLoop forMode:UITrackingRunLoopMode];
        }
        
        self.displayLink.paused = NO;
        
        self.frameCountInLastInterval = @0;
        self.lastLogTime = @(CFAbsoluteTimeGetCurrent());
        
        [self performSelector:_cmd withObject:self afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
        
    } else {
        self.displayLink.paused = YES;
        
        [self performSelector:_cmd withObject:self afterDelay:0 inModes:@[UITrackingRunLoopMode]];
    }
}

- (void)screenDidUpdateWhileScrolling {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    
    if (!self.lastLogTime) {
        self.lastLogTime = @(currentTime);
    }
    
    NSTimeInterval delta = currentTime - self.lastLogTime.doubleValue;
    
    if (delta > 1) {
        self.totalScrollingTime = @(self.totalScrollingTime.doubleValue + delta);
        self.totalFrameCount = @(self.totalFrameCount.integerValue + self.frameCountInLastInterval.integerValue);
        CGFloat fps = self.frameCountInLastInterval.integerValue / delta;
        CGFloat totalFps = self.totalFrameCount.integerValue / self.totalScrollingTime.doubleValue;
        
        self.averageFPS = @(fps);
        self.totalAverageFPS = @(totalFps);
        
        self.frameCountInLastInterval = @0;
        self.lastLogTime = @(currentTime);
        
    } else {
        self.frameCountInLastInterval = @(self.frameCountInLastInterval.integerValue + 1);
    }
}

- (void)resetScrollingPerfromanceCounters {
    self.frameCountInLastInterval = @0;
    self.lastLogTime = @(CFAbsoluteTimeGetCurrent());
    self.totalScrollingTime = @0;
    self.totalFrameCount = @0;
}


#pragma mark - Getter & Setter

- (NSNumber *)averageFPS {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAverageFPS:(NSNumber *)averageFPS {
    objc_setAssociatedObject(self, @selector(averageFPS), averageFPS, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)totalAverageFPS {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTotalAverageFPS:(NSNumber *)totalAverageFPS {
    objc_setAssociatedObject(self, @selector(totalAverageFPS), totalAverageFPS, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CADisplayLink *)displayLink {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink {
    objc_setAssociatedObject(self, @selector(displayLink), displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)lastLogTime {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLastLogTime:(NSNumber *)lastLogTime {
    objc_setAssociatedObject(self, @selector(lastLogTime), lastLogTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)frameCountInLastInterval {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFrameCountInLastInterval:(NSNumber *)frameCountInLastInterval {
    objc_setAssociatedObject(self, @selector(frameCountInLastInterval), frameCountInLastInterval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)totalFrameCount {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTotalFrameCount:(NSNumber *)totalFrameCount {
    objc_setAssociatedObject(self, @selector(totalFrameCount), totalFrameCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)totalScrollingTime {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTotalScrollingTime:(NSNumber *)totalScrollingTime {
    objc_setAssociatedObject(self, @selector(totalScrollingTime), totalScrollingTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
