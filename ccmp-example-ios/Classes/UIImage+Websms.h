//
//  UIImage+Websms.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Websms)

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)imageWithGradient:(CGRect)frame startColor:(UIColor *)color1 endColor:(UIColor *)color2;

@end
