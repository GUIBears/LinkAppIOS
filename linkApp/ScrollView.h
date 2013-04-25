//
//  ScrollingText.m
//  linkApp
//
//  Created by Ryan Mord on 3/14/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLScrollviewDelegate <NSObject>

- (void)userTouch;
- (void)userDrag;
- (void)userEndTouch;

@end

@interface CLScrollview : UIScrollView

@property (nonatomic, assign) id <CLScrollviewDelegate> customDelegate;

@end
