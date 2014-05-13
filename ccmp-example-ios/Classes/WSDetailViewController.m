//
//  WSDetailViewController.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSDetailViewController.h"
#import "WSMessageDetailCell.h"

@interface WSDetailViewController () {
    CCMPMessageMO *message;
}
@end

@implementation WSDetailViewController
@synthesize messageId;

static float kChatBarMinHeight = 44.0;
static float kChatBarMaxHeight = 88.0;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self.chatBar setDelegate:self];
}


#pragma mark
#pragma mark - View life cylce

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    
    if (messageId) {
        message = [[SharedCCMP database] getMessageWithId:messageId];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setMessageRead];
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
}


#pragma mark
#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    [super keyboardWillShow:notification];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    float keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    layoutChatBarBottomConstraint.constant = keyboardHeight;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [super keyboardWillHide:notification];
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];

    layoutChatBarBottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    [self setMessageRead];
}

- (void)inboxUpdated:(NSNotification *)notif {
    if (messageId) {
        message = [[SharedCCMP database] getMessageWithId:messageId];
    }
    
    [self.tableView reloadData];
    
    [self hideProgressHud];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: CCMPNotificationInboxUpdated
                                                  object: nil];
}

- (void)messageSent:(NSNotification *)notif {
    [self hideProgressHud];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: CCMPNotificationMessageSent
                                                  object: nil];
}


#pragma mark
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WSMessageDetailCell heightForMessage:message];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WSMessageDetailCell";
    WSMessageDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[WSMessageDetailCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    [cell configureCellWithMessage:message];
    
    return cell;
}


#pragma mark
#pragma mark - Private methods

- (void)configureChatBarHeight:(CGFloat)contentHeight {
    layoutChatBarHeightConstraint.constant = contentHeight;
    [self.view layoutIfNeeded];
}

- (void)setMessageRead {
    if (message && [message.read boolValue] == NO) {
        
        CLogDebug(@"MessageId = %@", message.messageId);
        
        [[SharedCCMP database] updateMessage:message read:YES];
        [[SharedCCMP database] commit:^(BOOL success) {
            CLogVerbose(@"Update finished - %d", success);
        }];
    }
}


#pragma mark
#pragma mark - WSChatBar delegate

- (void)chatBar:(WSChatBar *)bar changeInputTextView:(UITextView *)textView {
    CGFloat contentHeight = 0;
    if (IS_IOS7) {
        contentHeight = textView.contentSize.height - textView.font.pointSize - 19.0;
    } else {
        contentHeight = textView.contentSize.height - textView.font.pointSize - 20.0;
    }
    
    contentHeight += kChatBarMinHeight;
    
    if (contentHeight < kChatBarMinHeight) {
        [self configureChatBarHeight:kChatBarMinHeight];
    } else if (contentHeight > kChatBarMaxHeight) {
        [self configureChatBarHeight:kChatBarMaxHeight];
    } else {
        [self configureChatBarHeight:contentHeight];
    }
}

- (void)chatBar:(WSChatBar *)bar sendButtonPressed:(id)sender {
    if (bar.inputText.length == 0) {
        return;
    }
    
    CLogDebug(@"Try to answer message %@", messageId);
    
    // Add observer to detect, when message is sent
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(messageSent:)
                                                 name: CCMPNotificationMessageSent
                                               object: nil];
    
    [self.chatBar resignFirstResponder];
    
    [self showProgressHudWithMessage:NSLocalizedString(@"progressSendMessage", @"")];
    
    // Tell CCMP to send message
    [SharedCCMP sendMessage: bar.inputText
                toRecipient: message.recipient
                  inReplyTo: messageId];
}

@end
