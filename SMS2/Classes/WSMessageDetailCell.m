//
//  WSMessageDetailCell.m
//  SMS2
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import "WSMessageDetailCell.h"
#import "WSAvatarService.h"
#import "UIImage+Websms.h"

@implementation WSMessageDetailCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [[[NSBundle mainBundle] loadNibNamed:@"WSMessageDefaultCell" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
        
        // Do additional configuration of card border
        [cardView.layer setBorderColor:[UIColor colorWithHexString:@"#e0e0e0"].CGColor];
        [cardView.layer setBorderWidth:0.5];
        
        // Do additional configuration of avatar border
        [avatarView.layer setBorderColor:[UIColor colorWithHexString:@"#d9d9d9"].CGColor];
        [avatarView.layer setBorderWidth:0.5];
        [avatarView.layer setCornerRadius:2.5];
        [avatarView.layer setMasksToBounds:YES];
    }
    return self;
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

- (void)configureCellWithMessage:(CCMPMessageMO *)msg {
    self.message = msg;
    
    __block CCMPAccountMO *accountInfo = msg.account;
    
    if (accountInfo && accountInfo.displayName) {
        nameLabel.text = accountInfo.displayName;
    } else {
        nameLabel.text = msg.recipient;
    }
    
    if (accountInfo && accountInfo.avatarURL) {
        UIImage *avatar = [SharedAvatarService avatarForAccount:accountInfo];
        
        if (avatar) {
            [self setAvatar:avatar];
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
                                        forDate: msg.date];
    
    if (day1 - currentDay == 0) {
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
        dateLabel.text =  [timeFormatter stringFromDate:msg.date];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        dateLabel.text =  [dateFormatter stringFromDate:msg.date];
    }
    
    // Set message text
    messageLabel.text = msg.content;
}


#pragma mark
#pragma mark - Class methods

+ (CGFloat)heightForMessage:(CCMPMessageMO *)message {
    CGSize size = [message.content sizeWithFont: [UIFont fontWithName:@"Avenir-Book" size:14.0]
                              constrainedToSize: CGSizeMake(280.0, CGFLOAT_MAX)
                                  lineBreakMode: NSLineBreakByWordWrapping];
    
    return size.height + 66.0;
}

@end
