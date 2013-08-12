//
//  Time.m
//  linkApp
//
//  Created by Bernard Ferguson on 8/3/13.
//  Copyright (c) 2013 Ryan Mord. All rights reserved.
//

#import "Time.h"

@implementation Time
@synthesize timeString, m, time, color;

-(Time*)initWithTime:(NSString*)_timeString andM:(NSString*)_m{
    self.m=_m;
    self.color=[UIColor colorWithRed:0.5 green:0.71 blue:0.71 alpha:1.0];
    timeString = _timeString;
    [self convertTimeString];
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"hh:mm"];
    time = [df dateFromString:timeString];
    if([m isEqualToString:@"pm"]){
        NSTimeInterval twelveHours = 12*60*60;
        time = [time dateByAddingTimeInterval:twelveHours];
    }
    return self;
}


-(void)convertTimeString{
    NSRange range;
    range=[timeString rangeOfString:@"*"];
    if(range.location != NSNotFound){
       // NSLog(@"*");
        timeString =[timeString substringFromIndex:1];
        color= [UIColor colorWithRed:0.5 green:0.91 blue:0.81 alpha:1.0];
    }
    else{
        range=[timeString rangeOfString:@"#"];
        if(range.location != NSNotFound){
           // NSLog(@"#");
            timeString =[timeString substringFromIndex:1];
            color = [UIColor colorWithRed:0.9 green:0.2 blue:0.2 alpha:1.0];
        }
    }

}
@end
