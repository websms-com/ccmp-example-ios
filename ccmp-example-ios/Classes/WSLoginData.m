//
//  WSLoginData.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 11.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSLoginData.h"

@implementation WSLoginData
@synthesize countryCode, dialPrefix;

- (id)init {
    self = [super init];
    
    if (self) {
        countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    }
    
    return self;
}

@end
