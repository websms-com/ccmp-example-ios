//
//  WSPinVerificationViewController.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSPinVerificationViewController.h"
#import "WSAppDelegate.h"

@implementation WSPinVerificationViewController
@synthesize msisdn;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark
#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set verify pin for example project. Only valid with given phone number and API-Key
    [pinTextField setText:CCMP_TEST_VERIFYPIN];
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(deviceVerifiedSucessfully:)
                                                 name: CCMPNotificationVerifiedDevice
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: CCMPNotificationVerifiedDevice
                                                  object: nil];
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
}


#pragma mark
#pragma mark - IBActions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextButtonPressed:(id)sender {
    // Verify address
    if (pinTextField.text.length < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                        message: NSLocalizedString(@"alertPinInvalidText", @"")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString(@"buttonCancelTitle", @"")
                                              otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    if (!IS_TALL_IPHONE) {
        [pinTextField resignFirstResponder];
    }
    
    [self showProgressHudWithMessage:NSLocalizedString(@"progressVerifyPinTitle", @"")];
    
    // Verify pin with the ccmp
    [SharedCCMP verifyMsisdn: msisdn
                     withPin: pinTextField.text];
}


#pragma mark
#pragma mark - Notifications

- (void)deviceVerifiedSucessfully:(NSNotification *)notification {
    
    [self hideProgressHud];
    
    // Handle api errors
    NSError *err = notification.object;
    if (err) {
        NSString *alertMessage = [NSString stringWithFormat:NSLocalizedString(@"errorInvalidPinText", @""), err.localizedDescription];
        WSPlainAlert(alertMessage);
        return;
    }
    
    [SharedAppDelegate loginUser];
}


@end
