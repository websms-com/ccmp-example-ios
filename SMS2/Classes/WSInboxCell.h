//
//  WSInboxCell.h
//  SMS2
//
//  Created by Christoph Lückler on 11.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSInboxCell : UITableViewCell {
    IBOutlet UIImageView *avatarView;
    IBOutlet UILabel *senderNameLabel;
    IBOutlet UILabel *messageExcerptLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIImageView *disclosureIndicator;
    IBOutlet UIView *statusIndicator;
    IBOutlet UIImageView *attachmentIndicator;
    
    IBOutlet NSLayoutConstraint *layoutSenderNameLeftConstraint;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureCellWithMessage:(CCMPMessageMO *)message;

@end
