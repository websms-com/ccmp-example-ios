//
//  WSInboxViewController.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 11.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSInboxViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UILabel *noMessageLabel;
    NSFetchedResultsController *fetchedMessages;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

- (void)openMessageWithId:(NSNumber *)messageId;

@end
