//
//  WSLoginViewController.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSLoginViewController.h"
#import "WSPinVerificationViewController.h"
#import "WSLoginData.h"

@interface WSLoginViewController () {
    WSLoginData *loginData;
}

@end

@implementation WSLoginViewController

static NSString *kSegueToNextVC = @"segueToPinVerificationView";


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        loginData = [WSLoginData new];
    }
    return self;
}


#pragma mark
#pragma mark - View life cylce

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set phone number for example project
    [addressTextField setText:CCMP_TEST_ADDRESS];
}

- (void)viewDidAppear:(BOOL)animated {
    // Check if addressField isFirstResponder, because viewWillAppear is not called after navigation stack pop
    if (!addressTextField.isFirstResponder) {
        [addressTextField becomeFirstResponder];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(pinSendSuccessfull:)
                                                 name: CCMPNotificationSentPin
                                               object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: CCMPNotificationSentPin
                                                  object: nil];
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
}


#pragma mark
#pragma mark - Segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[WSPinVerificationViewController class]]) {
        WSPinVerificationViewController *nextVC = segue.destinationViewController;
        nextVC.msisdn = [NSNumber numberWithLongLong:[addressTextField.text longLongValue]];
    }
}


#pragma mark
#pragma mark - IBActions

- (IBAction)nextButtonPressed:(id)sender {
    CLogVerbose();
    
    // Verify address
    if (addressTextField.text.length <= 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: nil
                                                        message: NSLocalizedString(@"alertMSISDNTooShortText", @"")
                                                       delegate: nil
                                              cancelButtonTitle: NSLocalizedString(@"buttonCancelTitle", @"")
                                              otherButtonTitles: nil];
        
        [alert show];
        return;
    }
    
    [self showProgressHudWithMessage:NSLocalizedString(@"progressSendPinVerificationTitle", @"")];
    
    // Send pin request to the ccmp
    [SharedCCMP sendPinRequest:[NSNumber numberWithLongLong:[addressTextField.text longLongValue]]];
}


#pragma mark
#pragma mark - Notifications

- (void)pinSendSuccessfull:(NSNotification *)notification {
    CLogVerbose();
    
    [self hideProgressHud];
    
    // Handle api errors
    NSError *err = notification.object;
    if (err) {
        NSString *alertMessage = [NSString stringWithFormat:NSLocalizedString(@"errorGeneralText", @""), err.localizedDescription];
        WSPlainAlert(alertMessage);
        return;
    }
    
    // Perform segue to load next view
    [self performSegueWithIdentifier: kSegueToNextVC
                              sender: self];
}

@end
