//
//  WSInboxViewController.m
//  SMS2
//
//  Created by Christoph Lückler on 11.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSInboxViewController.h"
#import "WSInboxCell.h"
#import "WSDetailViewController.h"

@implementation WSInboxViewController

static NSString *kSegueToNewMessageView = @"segueToMessageVC";
static NSString *kSegueToSettingsView = @"segueToSettingsVC";

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    // Set refesh control color
    [self.refreshControl setTintColor:[UIColor blackColor]];
}


#pragma mark
#pragma mark - View life cylce

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add observer
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(inboxUpdateComplete:)
                                                 name: CCMPNotificationInboxUpdated
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(databaseCommited:)
                                                 name: CCMPNotificationDatabaseCommited
                                               object: nil];
    
    // Localize strings
    [noMessageLabel setText:NSLocalizedString(@"inboxViewNoMessagesText", @"")];
    
    // Hack around crash with UIScrollView when adding UIRefreshControl as subview
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshOutboxPulled:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = self.refreshControl;
    
    // Get messages from library
    fetchedMessages = [[SharedCCMP database] messageResultControllerWithOutgoing:NO];
    fetchedMessages.delegate = self;
    [fetchedMessages performFetch:nil];
    
    [self configureInbox];
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
}


#pragma mark
#pragma mark - Segue handling

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[WSDetailViewController class]] && [sender isKindOfClass:[NSNumber class]]) {
        WSDetailViewController *nextVC = segue.destinationViewController;
        nextVC.messageId = sender;
    }
}


#pragma mark
#pragma mark - IBActions

- (IBAction)refreshOutboxPulled:(id)sender {
    [SharedCCMP updateInbox];
}


#pragma mark
#pragma mark - Notifications

- (void)inboxUpdateComplete:(NSNotification *)notification {
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
}

- (void)databaseCommited:(NSNotification *)notification {
    [self.tableView reloadRowsAtIndexPaths: [self.tableView indexPathsForVisibleRows]
                          withRowAnimation: UITableViewRowAnimationNone];
}


#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [fetchedMessages.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[fetchedMessages sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedMessages sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = NSStringFromClass([WSInboxCell class]);
    WSInboxCell *cell = (WSInboxCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[WSInboxCell alloc] initWithReuseIdentifier:cellIdentifier];
    }
    
    [cell configureCellWithMessage:[fetchedMessages objectAtIndexPath:indexPath]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CCMPMessageMO *message = [fetchedMessages objectAtIndexPath:indexPath];
        
        [[SharedCCMP database] deleteMessage: message
                               andReferences: YES];
        
        [SharedCCMP.database commit];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CCMPMessageMO *message = [fetchedMessages objectAtIndexPath:indexPath];
    [self openMessageWithId:message.messageId];
}


#pragma mark
#pragma mark - NSFetchedResultsController delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
            case NSFetchedResultsChangeInsert: {
                [self.tableView insertSections: [NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation: UITableViewRowAnimationNone];
                break;
            }
            case NSFetchedResultsChangeDelete: {
                [self.tableView deleteSections: [NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation: UITableViewRowAnimationNone];
                break;
            }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            case NSFetchedResultsChangeInsert: {
                [self.tableView insertRowsAtIndexPaths: [NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation: UITableViewRowAnimationNone];
                break;
            }
            case NSFetchedResultsChangeDelete: {
                [self.tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath]
                                      withRowAnimation: UITableViewRowAnimationNone];
                break;
            }
            case NSFetchedResultsChangeUpdate: {
                WSInboxCell *cell = (WSInboxCell *)[self.tableView cellForRowAtIndexPath:newIndexPath];
                [cell configureCellWithMessage:[fetchedMessages objectAtIndexPath:newIndexPath]];
                break;
            }
            case NSFetchedResultsChangeMove: {
                [self.tableView moveRowAtIndexPath: indexPath
                                       toIndexPath: newIndexPath];
                break;
            }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self configureInbox];
}


#pragma mark
#pragma mark - Public methods

- (void)openMessageWithId:(NSNumber *)messageId {
    if (!messageId) {
        return;
    }
    
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    [self performSegueWithIdentifier: kSegueToNewMessageView
                              sender: messageId];
}


#pragma mark
#pragma mark - Private methods

- (void)configureInbox {
    // When table view is empty display info message
    if ([self.tableView numberOfRowsInSection:0] == NSNotFound || [self.tableView numberOfRowsInSection:0] == 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        noMessageLabel.hidden = NO;
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        noMessageLabel.hidden = YES;
    }
    
    [self.view layoutSubviews];
}

@end
