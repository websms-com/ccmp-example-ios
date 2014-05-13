//
//  ClientGrowingTextView.h
//  mysms client
//
//  Created by Christoph Lückler on 30.11.12.
//  Copyright (c) 2012 Up To Eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientGrowingTextView : UITextView {
    float m_minimumContentOffsetHeight;
}

@property (nonatomic, readonly) CGSize sizeOfText;
@property (nonatomic, assign) float minimumContentOffsetHeight;

@end
