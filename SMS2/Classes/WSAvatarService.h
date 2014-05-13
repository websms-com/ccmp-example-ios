//
//  WSAvatarService.h
//  SMS2
//
//  Created by Christoph Lückler on 17.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedAvatarService [WSAvatarService sharedService]

@interface WSAvatarService : NSObject {
    __block NSMutableArray *loadQueue;
}

@property (nonatomic, assign) BOOL isLoading;

+ (WSAvatarService *)sharedService;

/**
 *  Adds the account information to a queue to download the avatar file.
 *
 *  @param account The account object of the avatar that should be downloaded
 */
- (void)loadAvatarFromAccount:(CCMPAccountMO *)account;

/**
 *  Returns the cached avatar for an given account.
 *
 *  @param account The account object of the avatar
 *  @return An UIImage with the avatar loaded
 */
- (UIImage *)avatarForAccount:(CCMPAccountMO *)account;

@end
