//
//  UIImage+IRImageryAdditions.h
//  IRImagery
//
//  Created by Evadne Wu on 6/16/11.
//  Copyright (c) 2011 Iridia Productions. All rights reserved.
//
//	Portions of code in this class adapted from UIImage+Resize.m
//  Created by Trevor Harmon
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef void (^IRImageWritingCallback) (BOOL didWrite, NSError *error);


@interface UIImage (IRAdditions)

- (UIImage *) irStandardImage;
- (UIImage *) irDecodedImage;
- (BOOL) irIsDecodedImage;

- (UIImage *) irScaledImageWithSize:(CGSize)aSize;

@property (nonatomic, readwrite, retain, getter=irRepresentedObject, setter=irSetRepresentedObject:) id irRepresentedObject;

- (void) irWriteToSavedPhotosAlbumWithCompletion:(IRImageWritingCallback)aBlock;

+ (BOOL) validateContentsOfFileAtPath:(NSString *)path error:(NSError **)error;

@end
