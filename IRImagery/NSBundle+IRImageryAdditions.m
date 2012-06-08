//
//  NSBundle+IRImageryAdditions.m
//  IRImagery
//
//  Created by Evadne Wu on 6/8/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "NSBundle+IRImageryAdditions.h"

@implementation NSBundle (IRImageryAdditions)

- (UIImage *) irImageNamed:(NSString *)name {

	NSBundle *bundle = self;

	NSString *baseName = [name stringByDeletingPathExtension];
	NSString *type = [[name pathExtension] length] ? [name pathExtension] : @"png";
	NSString *scaleSuffix = [NSString stringWithFormat:@"@%0.0fx", [UIScreen mainScreen].scale];
	NSString *deviceSuffix = ((NSString * []){
		[UIUserInterfaceIdiomPad] = @"~ipad",
		[UIUserInterfaceIdiomPhone] = @"~iphone"
	})[[UIDevice currentDevice].userInterfaceIdiom];	
	
	__block NSString *foundPath = nil;
	
	[[NSArray arrayWithObjects:
		
		[[baseName stringByAppendingString:deviceSuffix] stringByAppendingString:scaleSuffix],	
		[baseName stringByAppendingString:deviceSuffix],
		[baseName stringByAppendingString:scaleSuffix],
		baseName,
	
	nil] enumerateObjectsUsingBlock: ^ (NSString *fileName, NSUInteger idx, BOOL *stop) {
	
		NSString *prospectivePath = [bundle pathForResource:fileName ofType:type];
		if (prospectivePath) {
		
			foundPath = prospectivePath;
			*stop = YES;
		
		}
		
	}];
	
	if (!foundPath)
		return nil;
	
	NSData *imageData = [NSData dataWithContentsOfMappedFile:foundPath];
	foundPath = nil;
	
	CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((__bridge CFDataRef)imageData);
	CGImageRef imageRef = CGImageCreateWithPNGDataProvider(providerRef, NULL, NO, kCGRenderingIntentDefault);
	
	CGFloat scale = [UIScreen mainScreen].scale;
	UIImage *image = [UIImage imageWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
		
	CGDataProviderRelease(providerRef);
	CGImageRelease(imageRef);
	
	return image;

}

@end
