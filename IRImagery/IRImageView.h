//
//  IRImageView.h
//  IRImagery
//
//  Created by Evadne Wu on 12/13/11.
//  Copyright (c) 2011 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {	
	
	IRImageViewOptionAsynchronousAssignment = 1,
	IRImageViewOptionSynchronousAssignment = 2
	
}; typedef NSUInteger IRImageViewOptions;


@class IRImageView;
@protocol IRImageViewDelegate

- (void) imageViewDidUpdate:(IRImageView *)anImageView;

@end


@interface IRImageView : UIImageView

@property (nonatomic, readwrite, weak) id<IRImageViewDelegate> delegate;

- (void) setImage:(UIImage *)anImage withOptions:(IRImageViewOptions)options;

@end
