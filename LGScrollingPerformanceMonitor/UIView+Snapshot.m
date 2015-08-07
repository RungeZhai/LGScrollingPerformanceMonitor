//
//  UIView+Snapshot.m
//  ILSPrivatePhoto
//
//  Created by liuge on 9/29/14.
//  Copyright (c) 2014 ZiXuWuYou. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

- (UIImage *)toImage {
    return [self toImageWithScale:0];
}

- (UIImage *)toImageWithScale:(CGFloat)scale {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    
    if ([self isKindOfClass:[UIScrollView class]]) {
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGPoint offset = [(UIScrollView *)self contentOffset];
        
        CGContextTranslateCTM(ctx, -offset.x, -offset.y);
    }
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {  // iOS7 or later
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshot;
}


- (UIImage *)toImageInRect:(CGRect)rect {
    return [self toImageInRect:rect scale:0];
}


- (UIImage *)toImageInRect:(CGRect)rect scale:(CGFloat)scale {
    
    UIImage *wholeSnapshot = [self toImageWithScale:scale];
    
    UIImage *snapshot = nil;
    if (wholeSnapshot) {
        CGRect imageRect = CGRectMake(rect.origin.x * wholeSnapshot.scale,
                                      rect.origin.y * wholeSnapshot.scale,
                                      rect.size.width * wholeSnapshot.scale,
                                      rect.size.height * wholeSnapshot.scale);
        
        CGImageRef imageRef = CGImageCreateWithImageInRect(wholeSnapshot.CGImage, imageRect);
        snapshot = [UIImage imageWithCGImage:imageRef scale:wholeSnapshot.scale orientation:wholeSnapshot.imageOrientation];
        CGImageRelease(imageRef);
    }
    
    return snapshot;
}

@end
