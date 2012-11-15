//
//  IRImagePageScrollView.m
//  IRImagery
//
//  Created by Evadne Wu on 5/28/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRImagePageScrollView.h"

@implementation IRImagePageScrollView

- (void) layoutSubviews {

	[super layoutSubviews];
	
	//	http://stackoverflow.com/questions/638299/uiscrollview-with-centered-uiimageview-like-photos-app
	
	UIView *tileContainerView = [self.subviews count] ? [self.subviews objectAtIndex:0] : nil;

	if (tileContainerView) {
	
		CGSize boundsSize = self.bounds.size;
		boundsSize.width -= self.contentInset.left + self.contentInset.right;
		boundsSize.height -= self.contentInset.top + self.contentInset.bottom;
		
		CGRect frameToCenter = tileContainerView.frame;

		frameToCenter.origin.x = (frameToCenter.size.width < boundsSize.width) ?
			(boundsSize.width - frameToCenter.size.width) / 2 :
			0;
			
		frameToCenter.origin.y = (frameToCenter.size.height < boundsSize.height) ?
			(boundsSize.height - frameToCenter.size.height) / 2 :
			0;
			
		tileContainerView.frame = frameToCenter;
	
	}

}

- (UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	UIView *superAnswer = [super hitTest:point withEvent:event];
	
	if (!superAnswer || (superAnswer == self))
		if (self.subviews)
			return [self.subviews objectAtIndex:0];
	
	return superAnswer;

}

@end
