//
//  WSDetailViewController.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSViewController.h"
#import "WSChatBar.h"

@interface WSDetailViewController : WSViewController <UITableViewDelegate, UITableViewDataSource, WSChatBarDelegate> {
    IBOutlet NSLayoutConstraint *layoutChatBarBottomConstraint;
    IBOutlet NSLayoutConstraint *layoutChatBarHeightConstraint;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet WSChatBar *chatBar;

@property (nonatomic, retain) NSNumber *messageId;

@end
