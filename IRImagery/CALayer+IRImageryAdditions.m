//
//  CALayer+IRImageryAdditions.m
//  IRImagery
//
//  Created by Evadne Wu on 9/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "CALayer+IRImageryAdditions.h"

@implementation CALayer (IRImageryAdditions)

- (UIImage *) irRenderedImageWithEdgeInsets:(UIEdgeInsets)insets {

	UIView *hostView = ((^{
		
		if (![self.delegate isKindOfClass:[UIView class]])
			return (UIView *)nil;
		
		UIView *delegateView = (UIView *)self.delegate;
		if (delegateView.layer == self)
			return (UIView *)delegateView;
		
		return (UIView *)nil;

	})());
	
	CGSize size = UIEdgeInsetsInsetRect(self.bounds, insets).size;
	CGFloat scale = ((^ {
		
		if (hostView.window.screen)
			return hostView.window.screen.scale;
			
		return [UIScreen mainScreen].scale;
		
	})());
	
	UIGraphicsBeginImageContextWithOptions(size, NO, scale);
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(imageContext, -1 * insets.left, -1 * insets.top);
	[self renderInContext:imageContext];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;

}

@end
