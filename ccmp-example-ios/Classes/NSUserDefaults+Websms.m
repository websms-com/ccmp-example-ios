//
//  NSUserDefaults+Websms.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "NSUserDefaults+Websms.h"

@implementation NSUserDefaults (Websms)

- (BOOL)debugLogEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kCLogDebugUserDefaultsKey];
}

- (void)setDebugLogEnabled:(BOOL)debugLogEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:debugLogEnabled forKey:kCLogDebugUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)inAppSoundEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"inAppSoundEnabled"];
}

- (void)setInAppSoundEnabled:(BOOL)inAppSoundEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:inAppSoundEnabled forKey:@"inAppSoundEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)inAppVibrationEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"inAppVibrationEnabled"];
}

- (void)setInAppVibrationEnabled:(BOOL)inAppVibrationEnabled {
    [[NSUserDefaults standardUserDefaults] setBool:inAppVibrationEnabled forKey:@"inAppVibrationEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)apnSoundSetting {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"apnSoundSetting"];
}

- (void)setApnSoundSetting:(NSString *)apnSoundSetting {
    [[NSUserDefaults standardUserDefaults] setObject:apnSoundSetting forKey:@"apnSoundSetting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark
#pragma mark - Initialization

- (void)initializeUserDefaults {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"inAppSoundEnabled"]) {
        [self setInAppSoundEnabled:YES];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"inAppVibrationEnabled"]) {
        [self setInAppVibrationEnabled:YES];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"apnSoundSetting"]) {
        [self setApnSoundSetting:@"0"];
    }
    
#ifdef STAGING
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kCLogDebugUserDefaultsKey]) {
        [self setDebugLogEnabled:YES];
    }
#endif
}

@end
