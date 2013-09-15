//
//  Time.h
//  linkApp
//
//  Created by Bernard Ferguson on 8/3/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Time : NSObject
@property (nonatomic,retain) NSString *timeString, *m, *sTimeString;
@property (nonatomic, retain) NSDate* time;
@property (nonatomic, retain) UIColor* textColor, *bgColor;
@property  Boolean classBus;


-(Time*)initWithTime:(NSString*)_time andM:(NSString*)_m;

@end
