//
//  WSMessageDetailCell.h
//  ccmp-example-ios
//
//  Created by Christoph Lückler on 13.03.14.
//  Copyright (c) 2014 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSMessageDetailCell : UITableViewCell {
    IBOutlet UIView *cardView;
    IBOutlet UIImageView *avatarView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *messageLabel;
}

@property (nonatomic , retain) CCMPMessageMO *message;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureCellWithMessage:(CCMPMessageMO *)message;

+ (CGFloat)heightForMessage:(CCMPMessageMO *)message;

@end
