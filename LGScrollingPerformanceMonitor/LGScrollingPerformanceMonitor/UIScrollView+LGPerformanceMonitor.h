//
//  UIScrollView+LGPerformanceMonitor.h
//  LGScrollingPerformanceMonitor
//
//  Created by liuge on 8/4/15.
//  Copyright (c) 2015 ZiXuWuYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LGPerformanceMonitor)

@property (strong, nonatomic, readonly) NSNumber      *averageFPS;
@property (strong, nonatomic, readonly) NSNumber      *totalAverageFPS;

@property (strong, nonatomic, readonly) CADisplayLink *displayLink;
@property (strong, nonatomic, readonly) NSNumber      *lastLogTime;
@property (strong, nonatomic, readonly) NSNumber      *frameCountInLastInterval;
@property (strong, nonatomic, readonly) NSNumber      *totalFrameCount;
@property (strong, nonatomic, readonly) NSNumber      *totalScrollingTime;

- (void)resetScrollingPerfromanceCounters;

@end
