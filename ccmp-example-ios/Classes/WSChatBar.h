//
//  WSChatBar.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 19.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClientGrowingTextView.h"
#import "ClientLineView.h"

@protocol WSChatBarDelegate;

@interface WSChatBar : UIView <UITextViewDelegate> {
    IBOutlet UIButton *sendButton;
    IBOutlet UITextField *backgroundTextField;
    IBOutlet ClientGrowingTextView *inputTextView;
    IBOutlet ClientLineView *topSeperator;
}

@property (nonatomic, assign) id <NSObject, WSChatBarDelegate> delegate;

@property (nonatomic, retain) NSString *inputText;

@end


@protocol WSChatBarDelegate
@optional
- (void)chatBar:(WSChatBar *)bar changeInputTextView:(UITextView *)textView;
- (void)chatBar:(WSChatBar *)bar sendButtonPressed:(id)sender;
@end