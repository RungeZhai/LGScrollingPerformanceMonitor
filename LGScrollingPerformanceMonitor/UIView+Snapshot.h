//
//  UIView+Snapshot.h
//  ILSPrivatePhoto
//
//  Created by liuge on 9/29/14.
//  Copyright (c) 2014 ZiXuWuYou. All rights reserved.
//
//  Capture a view into a UIImage.
//

#import <UIKit/UIKit.h>

@interface UIView (Snapshot)

// Follow device screen scaling([UIScreen mainScreen].scale).
// Use this option for making high resolution view elements snapshots to display on retina devices.
- (UIImage *)toImage;

// Force rendering in a given scale. Commonly used will be "1"
// Good for output or saving a static image with the (point) size of the view itself.
- (UIImage *)toImageWithScale:(CGFloat)scale;

// snapshot in a specific rect
- (UIImage *)toImageInRect:(CGRect)rect;

- (UIImage *)toImageInRect:(CGRect)rect scale:(CGFloat)scale;

@end
