//
//  UIView+IRImageryAdditions.m
//  IRImagery
//
//  Created by Evadne Wu on 9/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "CALayer+IRImageryAdditions.h"
#import "UIView+IRImageryAdditions.h"

@implementation UIView (IRImageryAdditions)

- (UIImage *) irRenderedImage {

	return [self.layer irRenderedImageWithEdgeInsets:UIEdgeInsetsZero];

}

- (UIImage *) irRenderedImageWithEdgeInsets:(UIEdgeInsets)insets {
	
	return [self.layer irRenderedImageWithEdgeInsets:insets];

}

@end
