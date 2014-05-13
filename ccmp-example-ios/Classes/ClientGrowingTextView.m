//
//  ClientGrowingTextView.m
//  mysms client
//
//  Created by Christoph Lückler on 30.11.12.
//  Copyright (c) 2012 Up To Eleven. All rights reserved.
//

#import "ClientGrowingTextView.h"

@implementation ClientGrowingTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


#pragma mark
#pragma mark - Overridden methods

- (void)setContentOffset:(CGPoint)s {
    
    /* check minimal content offset, to avoid ios bug */
    if (s.y < m_minimumContentOffsetHeight) {
        s.y = m_minimumContentOffsetHeight;
    }
    
    [super setContentOffset:s];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    
    // Fixed issue with layouting in iOS7 and wired calculation of content
    if (IS_IOS7) {
        [super setScrollEnabled:YES];
    } else {
        [super setScrollEnabled:scrollEnabled];
    }
}


#pragma mark
#pragma mark - Private methods

- (float)minimumContentOffsetHeight {
    return m_minimumContentOffsetHeight;
}

- (void)setMinimumContentOffsetHeight:(float)minimumContentOffsetHeight {
    m_minimumContentOffsetHeight = minimumContentOffsetHeight;
    
    if (self.contentOffset.y < m_minimumContentOffsetHeight) {
        [super setContentOffset:CGPointMake(self.contentOffset.x, m_minimumContentOffsetHeight)];
    }
}

- (CGSize)sizeOfText {
    CGSize size = [self.text sizeWithFont: self.font
                        constrainedToSize: CGSizeMake(self.frame.size.width - 10.0, FLT_MAX)
                            lineBreakMode: NSLineBreakByWordWrapping];
    return size;
}

@end

