//
//  UIColor+Extension.m
//  mysms client (iPad)
//
//  Created by Christoph Lückler on 22.05.13.
//  Copyright (c) 2013 Up To Eleven. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Client)

const NSDictionary *kColorCodeConfigFile;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cleanHex = [stringToConvert hasPrefix:@"#"] ? [stringToConvert substringFromIndex:1] : stringToConvert;

    NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithFormat:@"0x%@", cleanHex]];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
    
    if (cleanHex.length == 6) {
        int r = (hexNum >> 16) & 0xFF;
        int g = (hexNum >> 8) & 0xFF;
        int b = (hexNum) & 0xFF;
        
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    } else {
        int r = (hexNum >> 24) & 0xFF;
        int g = (hexNum >> 16) & 0xFF;
        int b = (hexNum >> 8) & 0xFF;
        float a = (float)(hexNum & 0xFF);
        
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:(a / 255.0)];
    }
}

@end
