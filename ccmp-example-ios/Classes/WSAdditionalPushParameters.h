//
//  WSAdditionalPushParameters.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 20.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSAdditionalPushParameters : NSObject

- (id)initWithMessage:(CCMPMessageMO *)message;

- (BOOL)hasKey:(NSString *)key;

- (id)elementForKey:(NSString *)key;

@end


// Available additional push parameters
#define APN_ADDPARAM_SUGGESTEDANSWERS @"suggestedAnswers"
