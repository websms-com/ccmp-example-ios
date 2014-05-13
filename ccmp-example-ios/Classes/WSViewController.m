//
//  WSViewController.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSViewController.h"

@implementation WSViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isKeyboardHidden = YES;
    }
    return self;
}


#pragma mark
#pragma mark - View life cylce

- (void)viewDidLoad {
    CLogVerbose(@"viewDidLoad");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark
#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    CLogVerbose(@"keyboardWillShow");
    
    self.isKeyboardHidden = NO;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CLogVerbose(@"keyboardWillHide");
    
    self.isKeyboardHidden = YES;
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    
}


#pragma mark
#pragma mark - Public methods

- (void)showProgressHudWithMessage:(NSString *)message {
    if (!self.progressHud) {
        self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
        self.progressHud.mode = MBProgressHUDModeIndeterminate;
        self.progressHud.removeFromSuperViewOnHide = YES;
        
        if (!IS_TALL_IPHONE && !self.isKeyboardHidden) {
            self.progressHud.yOffset = -88.0;
        }
    }
    
    CLogVerbose(@"showProgressHudWithMessage");
    
    [self.view addSubview:self.progressHud];
    
    [self.progressHud setLabelText:message];
    [self.progressHud show:YES];
}

- (void)hideProgressHud {
    CLogVerbose(@"hideProgressHud");
    
    [self.progressHud hide:YES];
}

@end
