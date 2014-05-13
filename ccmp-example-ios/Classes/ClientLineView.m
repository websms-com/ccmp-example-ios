//
//  ClientLineView.m
//  mysms client
//
//  Created by Christoph Lückler on 22.02.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "ClientLineView.h"

@implementation ClientLineView
@synthesize lineColor;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        lineColor = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        lineColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    if (self.frame.size.width != frame.size.width || self.frame.size.height != frame.size.height) {
        [self setNeedsDisplayInRect:frame];
    }
    
    [super setFrame:frame];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [lineColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, (self.bounds.size.height / 2.0)));
    
    CGContextStrokePath(context);
}

@end
