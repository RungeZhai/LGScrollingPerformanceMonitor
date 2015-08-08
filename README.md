# LGScrollingPerformanceMonitor
A UIScrollView FPS (Frames Per Second) Calculator

### Demo
![Demo Image](https://cloud.githubusercontent.com/assets/3366713/9149902/e6bd2506-3df2-11e5-8252-fafb8a1c6db2.gif)


### Usage
Drag `LGScrollingPerformanceMonitor.h` and `LGScrollingPerformanceMonitor.m` to your project. Observe the `averageFPS` key like this:
```
[self.tableView addObserver:self forKeyPath:@"averageFPS" options:NSKeyValueObservingOptionNew context:NULL];
```
and then in the `NSKeyValueObserving` call back get the FPS:
```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.tableView && [keyPath isEqualToString:@"averageFPS"]) {
        NSNumber *number = [change valueForKey:NSKeyValueChangeNewKey];
        // Do whatever you want with the FPS
    }
}
```
