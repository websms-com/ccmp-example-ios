//
//  NSUserDefaults+Websms.h
//  SMS2App
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StandardWebsmsUserDefaults [NSUserDefaults standardUserDefaults]

@interface NSUserDefaults (Websms)

@property (nonatomic, assign) BOOL debugLogEnabled;
@property (nonatomic, assign) BOOL inAppSoundEnabled;
@property (nonatomic, assign) BOOL inAppVibrationEnabled;
@property (nonatomic, retain) NSString *apnSoundSetting;

- (void)initializeUserDefaults;

@end
