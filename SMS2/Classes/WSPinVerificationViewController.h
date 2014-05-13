//
//  WSPinVerificationViewController.h
//  SMS2
//
//  Created by Christoph Lückler on 10.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSViewController.h"

@interface WSPinVerificationViewController : WSViewController {
    IBOutlet UITextField *pinTextField;
    IBOutlet UIButton *nextButton;
}

@property (nonatomic, retain) NSNumber *msisdn;

@end
