//
//  ClientLineView.h
//  mysms client
//
//  Created by Christoph Lückler on 22.02.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientLineView : UIView {}

@property (nonatomic, readonly) UIColor *lineColor;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color;

@end
