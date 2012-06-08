//
//  IRImagePageView.h
//  IRImagery
//
//  Created by Evadne Wu on 8/5/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IRImagePageView;
@protocol IRImagePageViewDelegate <NSObject>

- (void) imagePageViewDidReceiveUserInteraction:(IRImagePageView *)imageView;

@end


@interface IRImagePageView : UIView

+ (id) viewForImage:(UIImage *)image;

@property (nonatomic, readwrite, assign) id<IRImagePageViewDelegate> delegate;
@property (nonatomic, readwrite, retain) UIImage *image;

- (void) setImage:(UIImage *)newImage animated:(BOOL)animate synchronized:(BOOL)sync;
- (void) reset;

@end
