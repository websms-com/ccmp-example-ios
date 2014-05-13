//
//  WSChatBar.m
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 19.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSChatBar.h"
#import "UIColor+Extension.h"

@implementation WSChatBar
@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    backgroundTextField.placeholder = NSLocalizedString(@"placeholderChatBarText", @"");
    
    [sendButton setTitle:NSLocalizedString(@"buttonSendTitle", @"") forState:UIControlStateNormal];
    [sendButton setTintColor:[UIColor colorWithHexString:@"#57cb8e"]];
    
    inputTextView.minimumContentOffsetHeight = 1;
}

- (void)dealloc {
    CLogVerbose(@"dealloc");
}


#pragma mark
#pragma mark - Custom Getter & Setter

- (NSString *)inputText {
    return inputTextView.text;
}

- (void)setInputText:(NSString *)inputText {
    inputTextView.text = inputText;
}


#pragma mark
#pragma mark - Overridden methods

- (BOOL)resignFirstResponder {
    return [inputTextView resignFirstResponder];
}

- (BOOL)isFirstResponder {
    return [inputTextView isFirstResponder];
}


#pragma mark
#pragma mark - IBActions

- (IBAction)sendButtonPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(chatBar:sendButtonPressed:)]) {
        [_delegate chatBar:self sendButtonPressed:sender];
    }
}


#pragma mark
#pragma mark - UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    backgroundTextField.placeholder = nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(chatBar:changeInputTextView:)]) {
        [_delegate chatBar:self changeInputTextView:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        backgroundTextField.placeholder = NSLocalizedString(@"placeholderChatBarText", @"");
    }
}

@end
