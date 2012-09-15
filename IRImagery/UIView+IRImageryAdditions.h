//
//  UIView+IRImageryAdditions.h
//  IRImagery
//
//  Created by Evadne Wu on 9/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IRImageryAdditions)

- (UIImage *) irRenderedImage;
- (UIImage *) irRenderedImageWithEdgeInsets:(UIEdgeInsets)insets;

@end
