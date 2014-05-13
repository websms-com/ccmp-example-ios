//
//  WSAppDelegate.h
//  SMS2
//
//  Created by Christoph Lückler on 03.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SharedAppDelegate ((WSAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface WSAppDelegate : UIResponder <UIApplicationDelegate> {
    CLogService *logService;
    CCMP *ccmpService;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSDictionary *lastHandledNotification;

- (void)loginUser;

- (void)logoutUser;

- (UINavigationController *)currentNavigationController;

@end
