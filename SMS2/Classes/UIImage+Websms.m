//
//  UIImage+Websms.m
//  SMS2App
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "UIImage+Websms.h"

@implementation UIImage (Websms)

- (UIImage *)scaleToSize:(CGSize)size {
    float scale = 1.0f;
    if (self.size.width > size.width || self.size.height > size.height) {
        scale = fminf(size.width / self.size.width, size.height / self.size.height);
    }
    
    CGSize fitSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    
	UIGraphicsBeginImageContext(fitSize);
	[self drawInRect:CGRectMake(0, 0, fitSize.width, fitSize.height)];
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

+ (UIImage *)imageWithGradient:(CGRect)frame startColor:(UIColor *)color1 endColor:(UIColor *)color2 {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:(id)[color1 CGColor], (id)[color2 CGColor], nil];
    
    // Convert gradient layer to UIImage
    UIGraphicsBeginImageContext(frame.size);
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

@end
