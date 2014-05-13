//
//  WSAdditionalPushParameters.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 20.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSAdditionalPushParameters.h"

@interface WSAdditionalPushParameters () {
    NSDictionary *jsonObject;
}
@end

@implementation WSAdditionalPushParameters

- (id)initWithMessage:(CCMPMessageMO *)message {
    self = [super init];
    if (self) {
        if (!message.additionalPushParameter) {
            CLogWarn(@"No additionalPushParameter available");
            return nil;
        }
        
        NSError *jsonError;
        jsonObject = [NSJSONSerialization JSONObjectWithData: [message.additionalPushParameter dataUsingEncoding:NSUTF8StringEncoding]
                                                     options: 0
                                                       error: &jsonError];
        
        if (jsonError) {
            CLogWarn(@"%@ - %@", jsonError.domain, jsonError.description);
            return nil;
        }
    }
    return self;
}


#pragma mark
#pragma mark - Public methods

- (BOOL)hasKey:(NSString *)key {
    return [[jsonObject allKeys] containsObject:key];
}

- (id)elementForKey:(NSString *)key {
    return [jsonObject objectForKey:key];
}

@end
