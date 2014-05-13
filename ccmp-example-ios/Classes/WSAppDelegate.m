//
//  WSAppDelegate.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 03.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSAppDelegate.h"
#import "WSInboxViewController.h"

@implementation WSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Initialize log service
    logService = [[CLogService alloc] init];
    
    // Init userdefaults
    [StandardWebsmsUserDefaults initializeUserDefaults];
    
    // Initialize services
    ccmpService = [CCMP new];
    ccmpService.apiBaseURL = CCMP_TEST_BASEURL;
    ccmpService.apiKey = CCMP_TEST_APIKEY;
    ccmpService.enableLogging = YES;
    
    // Get access to APNS
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
    
    // Set rootview (Check if user is registred)
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if ([ccmpService isRegistered]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
        
        if (launchOptions) {
            NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            [self handleRemoteNotifications:remoteNotif];
        }
    } else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [ccmpService didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [ccmpService didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [ccmpService didReceiveLocalNotification:notification];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [ccmpService didReceiveRemoteNotification:userInfo];
    [self handleRemoteNotifications:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [ccmpService didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    [self handleRemoteNotifications:userInfo];
}


#pragma mark
#pragma mark - Private methods

- (void)handleRemoteNotifications:(NSDictionary *)remoteNotif {
    self.lastHandledNotification = remoteNotif;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        NSNumber *messageId = [NSNumber numberWithInt:[[remoteNotif objectForKey:@"message_id"] intValue]];
        UINavigationController *navVC = (UINavigationController *)self.window.rootViewController;
        WSInboxViewController *rootVC = [navVC.viewControllers objectAtIndex:0];
        
        if ([rootVC isKindOfClass:[WSInboxViewController class]] && messageId) {
            [rootVC openMessageWithId:messageId];
        }
    } 
}


#pragma mark
#pragma mark - Login / Logout

- (void)loginUser {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *sourcetVC = self.window.rootViewController;
    UIViewController *destVC = [storyboard instantiateInitialViewController];
    
    [UIView transitionFromView: sourcetVC.view
                        toView: destVC.view
                      duration: 0.5
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    completion: ^(BOOL finished) {
                        self.window.rootViewController = destVC;
                    }];
}

- (void)logoutUser {
    [ccmpService logout];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *sourcetVC = self.window.rootViewController;
    UIViewController *destVC = [storyboard instantiateInitialViewController];
    
    [UIView transitionFromView: sourcetVC.view
                        toView: destVC.view
                      duration: 0.5
                       options: UIViewAnimationOptionTransitionFlipFromRight
                    completion: ^(BOOL finished) {
                        self.window.rootViewController = destVC;
                    }];
}


#pragma mark
#pragma mark - Public methods

- (UINavigationController *)currentNavigationController {
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.window.rootViewController;
    } else {
        return nil;
    }
}

@end
