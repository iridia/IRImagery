//
//  UIImage+IRCompatibility.m
//  IRImagery
//
//  Created by Evadne Wu on 6/8/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "UIImage+IRCompatibility.h"

static void __attribute__((constructor)) initialize() {

	@autoreleasepool {
    
		if ([[[UIDevice currentDevice] systemVersion] localizedCompare:@"5.0"] == NSOrderedAscending) {
			
			Class class = [UIImage class];

			if (!class_addMethod(
				class,
				@selector(initWithCoder:), class_getMethodImplementation(class, @selector(_irInitWithCoder:)),
				protocol_getMethodDescription(@protocol(NSCoding), @selector(initWithCoder:), YES, YES).types
			)) {
				NSLog(@"Error swizzling -[UIImage initWithCoder:] off.  Expect mayhem.");
			}

			if (!class_addMethod(
				class, 
				@selector(encodeWithCoder:),
				class_getMethodImplementation(class, @selector(_irEncodeWithCoder:)), 
				protocol_getMethodDescription(@protocol(NSCoding), @selector(encodeWithCoder:), YES, YES).types)
			) {
				NSLog(@"Error swizzling -[UIImage encodeWithCoder:] off.  Expect mayhem.");
			}

		}
	
	}
	
}


@implementation UIImage (IRCompatibility)

- (id) _irInitWithCoder:(NSCoder *)decoder {
	
	return nil;
	
}

- (void) _irEncodeWithCoder:(NSCoder *)aCoder {
	
	//	?
	
}

@end
