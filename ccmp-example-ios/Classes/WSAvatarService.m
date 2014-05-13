//
//  WSAvatarService.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 17.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSAvatarService.h"
#import <EGOCache/EGOCache.h>

@implementation WSAvatarService
@synthesize isLoading;

static WSAvatarService *sharedInstance;

static int kAvatarCacheTimeoutInterval = INT_MAX;

#pragma mark
#pragma mark - Initialization

+ (WSAvatarService *)sharedService {
	return sharedInstance ?: [self new];
}

- (id)init {
	if (sharedInstance) {
        
	} else if ((self = sharedInstance = [super init])) {
        CLogDebug(@"Initialization ...");
        
        loadQueue = [NSMutableArray new];
        isLoading = NO;
	}
	return sharedInstance;
}


#pragma mark
#pragma mark - Private methods

- (void)loadAvatarsInQueue {
    CLogInfo(@"Start avatar loading queue (%@)", [NSNumber numberWithInteger:loadQueue.count]);
    
    while ([loadQueue count] > 0) {
        CCMPAccountMO *account = [loadQueue objectAtIndex:0];
        
        CLogDebug(@"load avatar in background: %@", account.accountId);
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:account.avatarURL]];
        NSURLResponse *urlResponse;
        NSError *err;
        
        NSData *data = [NSURLConnection sendSynchronousRequest: request
                                             returningResponse: &urlResponse
                                                         error: &err];
        
        if (!err && data.length > 0) {
            __block NSString *cacheKey = [[account.avatarURL componentsSeparatedByString:@"/"] lastObject];

            [[EGOCache globalCache] setData: data
                                     forKey: cacheKey
                        withTimeoutInterval: kAvatarCacheTimeoutInterval];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                account.cacheKey = cacheKey;
                [[SharedCCMP database] commit];
            });
        }
        
        [loadQueue removeObject:account];
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        isLoading = NO;
    });
}


#pragma mark
#pragma mark - Public methods

- (void)loadAvatarFromAccount:(CCMPAccountMO *)account {
    NSAssert([NSThread isMainThread], @"load have to be called on main thread");
    
    if ([loadQueue containsObject:account]) {
        return;
    }
    
    CLogDebug(@"load avatar from account %@", account.accountId);
    
    [loadQueue addObject:account];
    
    if (!isLoading) {
        isLoading = YES;

        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(void) {
                           [self loadAvatarsInQueue];
                       });
    }
}

- (UIImage *)avatarForAccount:(CCMPAccountMO *)account {
    if (!account) {
        return nil;
    }
    
    // Check if cached image is equal to avatar url
    NSString *newGeneratedCacheKey = [[account.avatarURL componentsSeparatedByString:@"/"] lastObject];
    if (![account.cacheKey isEqualToString:newGeneratedCacheKey] && [[EGOCache globalCache] hasCacheForKey:account.cacheKey]) {
        [[EGOCache globalCache] removeCacheForKey:account.cacheKey];
        return nil;
    }
    
    if ([[EGOCache globalCache] hasCacheForKey:account.cacheKey]) {
        return [[UIImage alloc] initWithData:[[EGOCache globalCache] dataForKey:account.cacheKey]];
    } else {
        return nil;
    }
}

@end
