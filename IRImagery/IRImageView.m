//
//  IRImageView.m
//  IRImagery
//
//  Created by Evadne Wu on 12/13/11.
//  Copyright (c) 2011 Iridia Productions. All rights reserved.
//

#import "IRImageView.h"
#import "UIImage+IRImageryAdditions.h"


@interface IRImageView ()

@property (nonatomic, readwrite, assign) void * lastImagePtr;

- (void) primitiveSetImage:(UIImage *)image;

@end

@implementation IRImageView
@synthesize lastImagePtr;
@dynamic delegate;

- (void) setImage:(UIImage *)newImage {

	[self setImage:newImage withOptions:IRImageViewOptionAsynchronousAssignment];

}

- (void) setImage:(UIImage *)newImage withOptions:(IRImageViewOptions)options {

	void * imagePtr = (__bridge void *)newImage;

	if (lastImagePtr == imagePtr)
		return;
  
  lastImagePtr = imagePtr;
	
  if (!newImage) {
	
		[self primitiveSetImage:nil];
    return;
		
  }

	if (options & IRImageViewOptionSynchronousAssignment) {
	
		[self primitiveSetImage:newImage];
		[self.delegate imageViewDidUpdate:self];
		
		return;
		
	}
	
	BOOL shouldEmptyContents = ![self.image.irRepresentedObject isEqual:newImage.irRepresentedObject];
	if (shouldEmptyContents) {
		
		[self primitiveSetImage:nil];
		
	}
	
	__weak IRImageView *wSelf = self;

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^ {

		if (!wSelf)
			return;

		if (wSelf.lastImagePtr != imagePtr)
			return;
		
		UIImage *decodedImage = [newImage irDecodedImage];

		dispatch_async(dispatch_get_main_queue(), ^ {
		
			if (!wSelf)
				return;
			
			if (wSelf.lastImagePtr != imagePtr)
				return;
			
			[wSelf primitiveSetImage:decodedImage];
			[wSelf.delegate imageViewDidUpdate:wSelf];
		
		});

	});

}

- (void) primitiveSetImage:(UIImage *)image {

	[super setImage:image];

}

@end
