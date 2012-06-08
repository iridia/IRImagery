//
//  IRImagePageView.m
//  IRImagery
//
//  Created by Evadne Wu on 8/5/11.
//  Copyright 2011 Iridia Productions. All rights reserved.
//

#import "IRImagePageView.h"
#import "IRImagePageScrollView.h"
#import "IRImageView.h"

CGRect IRImagePageViewAspectFit (CGRect rect, CGSize size) {

	CGFloat imageSizeRatio = size.width / size.height;
	CGFloat imageFrameRatio = rect.size.width / rect.size.height;
	
	if (imageSizeRatio == imageFrameRatio) {
		
		return rect;
		
	} else if (imageSizeRatio < imageFrameRatio) {

		CGSize heightFittingImageSize = (CGSize){
			CGRectGetHeight(rect) * imageSizeRatio,
			CGRectGetHeight(rect)
		};

		return (CGRect){
			(CGPoint) { 0.5f * (rect.size.width - heightFittingImageSize.width), 0 },
			heightFittingImageSize	
		};
	
	} else {
	
		CGSize widthFittingImageSize = (CGSize){
			CGRectGetWidth(rect),
			CGRectGetWidth(rect) / imageSizeRatio
		};

		return (CGRect){
			(CGPoint) { 0, 0.5f * (rect.size.height - widthFittingImageSize.height) },
			widthFittingImageSize	
		};
	
	}
	
}


@interface IRImagePageView () <UIScrollViewDelegate, IRImageViewDelegate>

@property (nonatomic, readwrite, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, readwrite, retain) UIScrollView *scrollView;
@property (nonatomic, readwrite, retain) IRImageView *imageView;

@end


@implementation IRImagePageView

@synthesize activityIndicator, imageView, scrollView;
@synthesize delegate;

+ (id) viewForImage:(UIImage *)image {

	IRImagePageView *returnedView = [[self alloc] init];
	returnedView.image = image;
	
	return returnedView;

}

- (void) waInit {
	
	[self addSubview:self.activityIndicator];
	[self addSubview:self.scrollView];
	
	#if 0
	
		self.clipsToBounds = NO;
		self.scrollView.clipsToBounds = NO;
		self.imageView.clipsToBounds = NO;
		
		self.scrollView.layer.borderColor = [UIColor blueColor].CGColor;
		self.scrollView.layer.borderWidth = 2.0f;
		
		self.imageView.layer.borderColor = [UIColor greenColor].CGColor;
		self.imageView.layer.borderWidth = 1.0f;
	
	#endif
	
	[self setNeedsLayout];
	
	self.exclusiveTouch = YES;
	
}

- (UIActivityIndicatorView *) activityIndicator {

	if (!activityIndicator) {
	
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
		activityIndicator.hidesWhenStopped = NO;
		activityIndicator.center = (CGPoint){ CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) };
		
		[activityIndicator startAnimating];
	
	}
	
	return activityIndicator;

}

- (UIScrollView *) scrollView {

	if (!scrollView) {
	
		scrollView = [[IRImagePageScrollView alloc] initWithFrame:self.bounds];
		scrollView.minimumZoomScale = 1.0f;
		scrollView.maximumZoomScale = 4.0f;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		
		[scrollView addSubview:self.imageView];
	
	}
	
	return scrollView;

}

- (IRImageView *) imageView {

	if (!imageView) {
	
		imageView = [[IRImageView alloc] initWithFrame:self.scrollView.bounds];
		imageView.center = CGPointZero;
		imageView.autoresizingMask = UIViewAutoresizingNone;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.delegate = self;
	
	}
	
	return imageView;

}

- (void) imageViewDidUpdate:(IRImageView *)anImageView {

	//	?

}

- (void) setImage:(UIImage *)newImage animated:(BOOL)animate synchronized:(BOOL)sync {

	NSTimeInterval duration = (animate ? 0.3f : 0.0f);
	NSTimeInterval delay = 0.0f;
	UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState;

	self.activityIndicator.hidden = !!newImage;
	
	[UIView animateWithDuration:duration delay:delay options:options animations:^{
	
		[self.imageView setImage:newImage withOptions:(sync ? IRImageViewOptionSynchronousAssignment : IRImageViewOptionAsynchronousAssignment)];
				
	} completion:nil];

}

+ (NSSet *) keyPathsForValuesAffectingImage {

	return [NSSet setWithObject:@"imageView.image"];

}

- (UIImage *) image {

	return self.imageView.image;

}

- (void) setImage:(UIImage *)newImage {

	[self setImage:newImage animated:NO synchronized:NO];

}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)aScrollView {

	return self.imageView;

}

- (void) setFrame:(CGRect)newFrame {

	BOOL frameChanged = !CGRectEqualToRect(self.frame, newFrame);

	[super setFrame:newFrame];
	
	if (frameChanged) {
		[self.scrollView setZoomScale:1.0f animated:NO];
		[self layoutSubviews];
	}

}

- (void) layoutSubviews {

	[super layoutSubviews];
	
	UIScrollView *sv = self.scrollView;
	UIImageView *iv = self.imageView;
	CGFloat zs = sv.zoomScale;
	
	if (!iv.image)
		return;
	
	if (zs == 1) {
		
		iv.frame = IRImagePageViewAspectFit(sv.bounds, iv.image.size);
		sv.contentSize = sv.bounds.size;
	
	}
	
}

- (void) scrollViewDidScroll:(UIScrollView *)sv {

	if (sv.panGestureRecognizer.state == UIGestureRecognizerStateChanged)
		[self.delegate imagePageViewDidReceiveUserInteraction:self];

}

- (void) scrollViewDidZoom:(UIScrollView *)sv {

	if (sv.pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
		[self.delegate imagePageViewDidReceiveUserInteraction:self];

	UIImageView *iv = self.imageView;
	CGFloat zs = sv.zoomScale;
	
	if (!iv.image)
		return;
	
	if (zs == 1) {
		
		iv.frame = IRImagePageViewAspectFit(sv.bounds, iv.image.size);
		sv.contentSize = sv.bounds.size;
	
	}

}

- (void) reset {

	[self.scrollView setZoomScale:1 animated:YES];
	
}

- (id) initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (!self)
		return nil;
		
	[self waInit];
	
	return self;

}

- (id) initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (!self)
		return nil;
		
	[self waInit];
	
	return self;

}

- (void) handleDoubleTap:(UITapGestureRecognizer *)aRecognizer {

	[self.delegate imagePageViewDidReceiveUserInteraction:self];

	//	TBD: use me
	//	CGPoint locationInImageView = [aRecognizer locationInView:self.imageView];
	
	UIScrollView *sv = self.scrollView;
	CGFloat zsMin = sv.minimumZoomScale, zsMax = sv.maximumZoomScale, zs = sv.zoomScale;
	
	if (zs == 1) {
	
		NSTimeInterval duration = 0.3f;
		NSTimeInterval delay = 0.0f;
		UIViewAnimationOptions options = UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState;
	
		[UIView animateWithDuration:duration delay:delay options:options animations:^{
			
			[sv setZoomScale:zsMax animated:NO];
			
			//	TBD: Make sure point locationInImageView in image view is actually visible with best efforts

		} completion:nil];
	
	} else if (zs > 1) {
	
		[sv setZoomScale:zsMin animated:YES];
	
	}

}

@end
