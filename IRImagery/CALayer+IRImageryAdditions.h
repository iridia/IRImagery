//
//  CALayer+IRImageryAdditions.h
//  IRImagery
//
//  Created by Evadne Wu on 9/14/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (IRImageryAdditions)

- (UIImage *) irRenderedImageWithEdgeInsets:(UIEdgeInsets)insets;

@end
