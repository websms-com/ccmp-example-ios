//
//  CLAliases.h
//
//  Created by Christoph Lückler on 26.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//


#pragma mark
#pragma mark - Device information

#define IS_TALL_IPHONE ([UIScreen mainScreen].bounds.size.height == 568)


#pragma mark
#pragma mark - iOS Versions

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)


#pragma mark
#pragma mark - Misc

#define WSPlainAlert(fmt, ...) [[[UIAlertView alloc] initWithTitle: nil \
                                                           message: fmt \
                                                          delegate: nil \
                                                 cancelButtonTitle: NSLocalizedString(@"buttonOkTitle", @"") \
                                                 otherButtonTitles: nil] show]
