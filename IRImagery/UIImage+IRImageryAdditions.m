//
//  UIImage+IRImageryAdditions.m
//  IRImagery
//
//  Created by Evadne Wu on 6/16/11.
//  Copyright (c) 2011 Iridia Productions. All rights reserved.
//

#import "UIImage+IRImageryAdditions.h"
#import <objc/runtime.h>

static NSString * const kRepresentedObject = @"-[UIImage(IRAdditions) representedObject]";
static NSString * const kDidWriteToSavedPhotosCallback = @"-[UIImage(IRAdditions) didWriteToSavedPhotosCallback]";
static NSString * const kIsDecodedImage = @"-[UIImage(IRAdditions) irIsDecodedImage]";


CGRect IRImageryTransposedRect (CGSize size, UIImageOrientation orientation) {

	switch (orientation) {
		
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			return (CGRect){ CGPointZero, (CGSize){ size.height, size.width } };
		
		default:
			return (CGRect){ CGPointZero, size };
		
	}

}


CGAffineTransform IRImageryStandardTransform (CGSize size, UIImageOrientation orientation) {

	CGAffineTransform transform = CGAffineTransformIdentity;

	switch (orientation) {
		
		case UIImageOrientationDown:             // EXIF = 3
		case UIImageOrientationDownMirrored: {   // EXIF = 4
			transform = CGAffineTransformTranslate(transform, size.width, size.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		}

		case UIImageOrientationLeft:             // EXIF = 6
		case UIImageOrientationLeftMirrored: {   // EXIF = 5
			transform = CGAffineTransformTranslate(transform, size.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
		}

		case UIImageOrientationRight:           // EXIF = 8
		case UIImageOrientationRightMirrored: {  // EXIF = 7
			transform = CGAffineTransformTranslate(transform, 0, size.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;
		}
		
		default: {
			break;
		}
		
	}

	switch (orientation) {
	
		case UIImageOrientationUpMirrored:      // EXIF = 2
		case UIImageOrientationDownMirrored: {  // EXIF = 4
			transform = CGAffineTransformTranslate(transform, size.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		}

		case UIImageOrientationLeftMirrored:    // EXIF = 5
		case UIImageOrientationRightMirrored: {  // EXIF = 7
			transform = CGAffineTransformTranslate(transform, size.height, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		}
		
		default: {
			break;
		}
		
	}

	return transform;

}


@implementation UIImage (IRAdditions)

- (CGSize) irPixelSize {

	return (CGSize) {
		self.size.width * self.scale,
		self.size.height * self.scale
	};

}

- (UIImage *) irStandardImage {

	if (self.imageOrientation == UIImageOrientationUp)
	if (self.scale == 1)
		return self;

	UIGraphicsBeginImageContextWithOptions([self irPixelSize], NO, 1.0);
	CGContextScaleCTM(UIGraphicsGetCurrentContext(), self.scale, self.scale);
	
	[self drawAtPoint:CGPointZero];
	
	return UIGraphicsGetImageFromCurrentImageContext();

}

- (UIImage *) irDecodedImage {

	if ([self irIsDecodedImage])
		return self;

	CGImageRef cgImage = [self irStandardImage].CGImage;
	size_t width = CGImageGetWidth(cgImage);
	size_t height = CGImageGetHeight(cgImage);
	
	if (!width && !height)
		return self;
		
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace) {
		
		CGBitmapInfo const bitmapInfo = kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little;
		CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, bitmapInfo);
		
		CGColorSpaceRelease(colorSpace);
		
		if (context) {
			
			CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
			CGImageRef outputImage = CGBitmapContextCreateImage(context);
			
			CGContextRelease(context);
			
			if (outputImage) {
				
				UIImage *image = [UIImage imageWithCGImage:outputImage];
				objc_setAssociatedObject(image, &kIsDecodedImage, (id)kCFBooleanTrue, OBJC_ASSOCIATION_ASSIGN);
				
				CGImageRelease(outputImage);
				return image;
				
			}
		
		}

	
	}

	return self;

}

- (BOOL) irIsDecodedImage {

	return !!objc_getAssociatedObject(self, &kIsDecodedImage);

}

- (UIImage *) irScaledImageWithSize:(CGSize)aSize {

	if (CGSizeEqualToSize(aSize, CGSizeZero))
		return self;
	
	CGSize const pixelSize = (CGSize){ aSize.width * self.scale, aSize.height * self.scale };
	CGAffineTransform const transform = IRImageryStandardTransform(pixelSize, self.imageOrientation);
	CGRect const rect = IRImageryTransposedRect(pixelSize, self.imageOrientation);
	
	CGColorSpaceRef const colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef const context = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	
	CGContextConcatCTM(context, transform);
	CGContextClearRect(context, rect);
	CGContextDrawImage(context, rect, self.CGImage);
	
	CGImageRef scaledImage = CGBitmapContextCreateImage(context);
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	UIImage *image = [UIImage imageWithCGImage:scaledImage scale:self.scale orientation:UIImageOrientationUp];
	
	CGImageRelease(scaledImage);
	
	return image;

}

- (id) irRepresentedObject {

	return objc_getAssociatedObject(self, &kRepresentedObject);

}

- (void) irSetRepresentedObject:(id)newObject {

	if (self.irRepresentedObject == newObject)
		return;
	
	objc_setAssociatedObject(self, &kRepresentedObject, newObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

+ (NSMutableSet *) contextInfoToImageWritingCallbacks {

	static NSMutableSet *set;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		set = [NSMutableSet set];
	});
	
	return set;

}

- (void) irWriteToSavedPhotosAlbumWithCompletion:(IRImageWritingCallback)aBlock {

	NSDictionary *contextInfo = [NSDictionary dictionaryWithObjectsAndKeys:
	
		[aBlock copy], kDidWriteToSavedPhotosCallback,
	
	nil];
	
	[[[self class] contextInfoToImageWritingCallbacks] addObject:contextInfo];
	
	UIImageWriteToSavedPhotosAlbum(self, self, @selector(handleDidWriteImageToSavedPhotosAlbum:withError:contextInfo:), (__bridge void *)contextInfo);

}

- (void) handleDidWriteImageToSavedPhotosAlbum:(UIImage *)image withError:(NSError *)error contextInfo:(NSDictionary *)contextInfo {

	IRImageWritingCallback callback = [contextInfo objectForKey:kDidWriteToSavedPhotosCallback];
	
	if (callback)
		callback(!error, error);
	
	[[[self class] contextInfoToImageWritingCallbacks] removeObject:contextInfo];

}

+ (BOOL) validateContentsOfFileAtPath:(NSString *)aFilePath error:(NSError **)error {

	if (!aFilePath)
		return YES;

	error = error ? error : &(NSError *){ nil };
	
	if (aFilePath && ![[NSFileManager defaultManager] fileExistsAtPath:aFilePath]) {
		
		*error = [NSError errorWithDomain:@"com.iridia.foundations" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithFormat:@"Image at %@ is actually nonexistant", aFilePath], NSLocalizedDescriptionKey,
		nil]];
		
		return NO;
		
	} else if (![UIImage imageWithData:[NSData dataWithContentsOfMappedFile:aFilePath]]) {
		
		*error = [NSError errorWithDomain:@"com.iridia.foundations" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSString stringWithFormat:@"Image at %@ can’t be decoded", aFilePath], NSLocalizedDescriptionKey,
		nil]];
		
		return NO;
		
	}

	return YES;

}

@end
