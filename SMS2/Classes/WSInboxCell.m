//
//  WSInboxCell.m
//  SMS2
//
//  Created by Christoph Lückler on 11.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSInboxCell.h"
#import <CCMP/CCMPApi.h>
#import <limits.h>
#import "WSAvatarService.h"
#import "UIImage+Websms.h"

@implementation WSInboxCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:@"WSInboxCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view setBackgroundColor:[UIColor colorWithHexString:@"#f5f5f5"]];
        [self setSelectedBackgroundView:view];
        
        // Do additional configuration of avatar border
        [avatarView.layer setBorderColor:[UIColor colorWithHexString:@"#e8e8e8"].CGColor];
        [avatarView.layer setBorderWidth:0.5];
        [avatarView.layer setCornerRadius:5.0];
        [avatarView.layer setMasksToBounds:YES];
        
        // Do additional configuration on status indicator
        [statusIndicator.layer setCornerRadius:ceil(statusIndicator.frame.size.width / 2.0)];
        [statusIndicator.layer setMasksToBounds:YES];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Because iOS7 set all subviews background color to clear color on selected state
    statusIndicator.backgroundColor = [UIColor colorWithHexString:@"#57cb8e"];
}


#pragma mark
#pragma mark - Private methods

- (void)setAvatar:(UIImage *)avatar {
    if (avatar.size.height > avatarView.frame.size.height || avatar.size.width > avatarView.frame.size.width) {
        avatar = [avatar scaleToSize:avatarView.frame.size];
    }
    
    avatarView.image = avatar;
}


#pragma mark
#pragma mark - Public methods

- (void)configureCellWithMessage:(CCMPMessageMO *)message {
    __block CCMPAccountMO *accountInfo = message.account;

    if (accountInfo && accountInfo.displayName) {
        senderNameLabel.text = accountInfo.displayName;
    } else {
        senderNameLabel.text = message.recipient;
    }
    
    if (accountInfo && accountInfo.avatarURL) {
        UIImage *image = [SharedAvatarService avatarForAccount:accountInfo];
        
        if (!image) {
            [SharedAvatarService loadAvatarFromAccount:accountInfo];
        } else {
            [self setAvatar:image];
        }
    } else {
        avatarView.image = [UIImage imageNamed:@"default-avatar.png"];
    }
    
    // Set formatted date
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    NSInteger currentDay = [calendar ordinalityOfUnit: NSDayCalendarUnit
                                               inUnit: NSEraCalendarUnit
                                              forDate: [NSDate date]];
    
    NSInteger day1 = [calendar ordinalityOfUnit: NSDayCalendarUnit
                                         inUnit: NSEraCalendarUnit
                                        forDate: message.date];
    
    if (day1 - currentDay == 0) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        dateLabel.text =  [timeFormatter stringFromDate:message.date];
    } else if (day1 - currentDay == -1) {
        dateLabel.text =  NSLocalizedString(@"dateFormatterYesterdayTitle", @"");
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        dateLabel.text =  [dateFormatter stringFromDate:message.date];
    }
    
    // Set message text
    messageExcerptLabel.text = message.content;
    
    // Set status indicator
    [statusIndicator setHidden:[message.read boolValue]];
    layoutSenderNameLeftConstraint.constant = statusIndicator.isHidden ? 68.0 : 85.0;
    [self layoutIfNeeded];
    
    // Set attachment indicator
    if (message.attachment) {
        [attachmentIndicator setHidden:NO];
        
        // Insert some spaces to align first row of text
        messageExcerptLabel.text = [@"     " stringByAppendingString:messageExcerptLabel.text];
    } else {
        [attachmentIndicator setHidden:YES];
    }
}

@end
