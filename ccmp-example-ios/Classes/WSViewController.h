//
//  WSViewController.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface WSViewController : UIViewController <MBProgressHUDDelegate>

@property (nonatomic, retain) MBProgressHUD *progressHud;

@property (nonatomic, assign) BOOL isKeyboardHidden;

/**
 *  Observer that is called when the keyboard will show. When overridden call [super keyboardWillShow:] to detect isKeyboardHidden correct.
 *
 *  @param notification The notification from the broadcast
 */
- (void)keyboardWillShow:(NSNotification *)notification;

/**
 *  Observer that is called when the keyboard will hide. When overridden call [super keyboardWillShow:] to detect isKeyboardHidden correct.
 *
 *  @param notification The notification from the broadcast
 */
- (void)keyboardWillHide:(NSNotification *)notification;

/**
 *  Observer that is called when the application moves to the background.
 *
 *  @param notification The notification from the broadcast
 */
- (void)applicationDidEnterBackground:(NSNotification *)notification;

/**
 *  Display an progress indicator (MBProgressHud) with a given message.
 *
 *  @param message The message that will be shown in the progress indicator
 */
- (void)showProgressHudWithMessage:(NSString *)message;

/**
 *  Hides the progress hud.
 */
- (void)hideProgressHud;

@end
