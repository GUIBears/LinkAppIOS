//
//  ScrollingText.m
//  linkApp
//
//  Created by Ryan Mord on 3/14/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLScrollview.h"

@interface CLTickerView : UIView <UIScrollViewDelegate, CLScrollviewDelegate> {
    NSTimer *scrollingTimer;
    NSInteger contentWidth;
    NSInteger labelWidth;
    BOOL startScrolling;
}

@property (nonatomic, retain) CLScrollview *scrollview;
@property (nonatomic, retain) NSString *marqueeStr;
@property (nonatomic, retain) UIFont *marqueeFont;

- (CGSize)labelSizeForText:(NSString *)text forFont:(UIFont *)font;

@end
